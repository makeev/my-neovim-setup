-- Servers to install via Mason and enable. Formatters/linters (stylua, prettier,
-- mypy) are NOT valid entries here -- mason-lspconfig only resolves LSP server
-- names. Those are handled by conform.nvim / nvim-lint instead.
local servers = { "basedpyright", "ruff", "lua_ls", "ts_ls", "gopls" }

return {
  -- Mason for managing LSP servers.
  -- NOTE: the project moved from `williamboman/*` to the `mason-org/*` org.
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason-lspconfig to integrate Mason with lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = servers,
      -- v2 renamed `automatic_installation` -> `automatic_enable`. We call
      -- vim.lsp.enable() ourselves below, so don't let Mason enable them twice.
      automatic_enable = false,
    },
  },

  -- LSP configuration (vim.lsp.config API, Nvim 0.11+)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason-lspconfig.nvim" },
    config = function()
      -- Configure capabilities for completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Set the position encoding (prefer UTF-8 for ruff)
      capabilities.general = capabilities.general or {}
      capabilities.general.positionEncodings = { "utf-8", "utf-16" }

      -- Use blink.cmp capabilities if available
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- Applies to every server, so each config below doesn't repeat it
      vim.lsp.config("*", { capabilities = capabilities })

      -- Basedpyright - pyright fork with code actions for imports
      vim.lsp.config.basedpyright = {
        cmd = { "basedpyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace", -- analyze the whole workspace for complete auto-imports
              autoImportCompletions = true, -- auto-imports in completion
            },
          },
        },
      }

      -- Ruff for linting and formatting
      vim.lsp.config.ruff = {
        cmd = { "ruff", "server" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "ruff.toml", ".git" },
      }

      -- Lua LS for the Neovim config
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".git" },
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = { vim.env.VIMRUNTIME },
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      -- TypeScript/JavaScript
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
      }

      -- Go
      vim.lsp.config.gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.work", "go.mod", ".git" },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      }

      vim.lsp.enable(servers)

      -- One LspAttach handler for every server, instead of a per-server
      -- `on_attach` (which vim.lsp.config supports but which duplicates work).
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          -- Keep ruff to linting/formatting only; basedpyright owns the rest
          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.renameProvider = false
            client.server_capabilities.definitionProvider = false
            client.server_capabilities.documentHighlightProvider = false
          end

          local opts = { buffer = bufnr, silent = true }

          -- Highlight references to the symbol under the cursor
          if client:supports_method("textDocument/documentHighlight") then
            local group =
              vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
              group = group,
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              group = group,
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- Keymaps
          vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", opts)
          vim.keymap.set(
            "n",
            "<leader>rn",
            vim.lsp.buf.rename,
            { buffer = bufnr, silent = true, desc = "LSP Rename" }
          )
          vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", opts)
          vim.keymap.set("n", "<C-m>", vim.lsp.buf.code_action, opts)
          -- Auto Import - filter code actions to import-only (basedpyright)
          vim.keymap.set("n", "<leader>ci", function()
            vim.lsp.buf.code_action({
              filter = function(action)
                return action.kind
                  and action.kind:match("quickfix")
                  and action.title:lower():match("import")
              end,
              apply = true, -- apply automatically when there is a single option
            })
          end, { buffer = bufnr, silent = true, desc = "Auto Import" })
        end,
      })

      -- Toggle between workspace and openFilesOnly LSP modes
      vim.g.lsp_workspace_mode = true -- start in workspace mode

      vim.keymap.set("n", "<leader>ts", function()
        vim.g.lsp_workspace_mode = not vim.g.lsp_workspace_mode
        local new_mode = vim.g.lsp_workspace_mode and "workspace" or "openFilesOnly"

        -- Reload the LSP clients with the new settings
        for _, client in ipairs(vim.lsp.get_clients({ name = "basedpyright" })) do
          client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
            basedpyright = {
              analysis = {
                diagnosticMode = new_mode,
              },
            },
          })
          client:notify("workspace/didChangeConfiguration", { settings = client.settings })
        end

        vim.notify("LSP diagnosticMode: " .. new_mode, vim.log.levels.INFO)
      end, { desc = "Toggle LSP workspace/local mode" })

      -- Diagnostics configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          -- "always" was the pre-0.11 spelling; it's a boolean now
          source = true,
        },
      })
    end,
  },
}
