return {
  -- Treesitter for Python syntax
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "python", "ninja", "rst" })
    end,
  },

  -- nvim-lint for mypy and other linters
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Configure linters per filetype
      lint.linters_by_ft = {
        python = { "mypy" },
      }

      -- Configure mypy to work with projects
      lint.linters.mypy.args = {
        "--show-column-numbers",
        "--show-error-end",
        "--hide-error-codes",
        "--hide-error-context",
        "--no-color-output",
        "--no-error-summary",
        "--no-pretty",
      }

      -- Run the linter only on save (to reduce load)
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = lint_augroup,
        callback = function()
          -- Run the linter only for Python files
          if vim.bo.filetype == "python" then
            lint.try_lint()
          end
        end,
      })

      -- Command to run the linter manually
      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },

  -- Settings for the Python LSP servers (pyright and ruff_lsp)
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- These servers are already configured in lsp.lua via mason-lspconfig
      -- Additional Python-specific settings can be added here
      return {}
    end,
  },

  -- DAP integration for debugging Python
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- Try to find debugpy on the system
      local debugpy_path = vim.fn.exepath("debugpy")
      if debugpy_path ~= "" then
        require("dap-python").setup(debugpy_path)
      end
    end,
  },
}

