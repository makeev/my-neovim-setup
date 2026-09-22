local mason = vim.fn.stdpath("data") .. "/mason"

-- Rust-specific keymaps under <leader>r (rn = rename and rh = harpoon stay free)
local function rust_keymaps(bufnr)
  local function map(lhs, cmd, desc)
    vim.keymap.set("n", lhs, "<cmd>RustLsp " .. cmd .. "<cr>", { buffer = bufnr, desc = desc })
  end
  -- Hover with actions (run/debug/go to impl) instead of the plain LSP hover
  map("K", "hover actions", "Rust Hover Actions")
  map("<leader>rr", "runnables", "Rust Runnables")
  map("<leader>rt", "testables", "Rust Testables")
  map("<leader>rd", "debuggables", "Rust Debuggables")
  map("<leader>rl", "run", "Rust Run Item Under Cursor")
  map("<leader>re", "explainError current", "Rust Explain Error")
  map("<leader>rD", "renderDiagnostic current", "Rust Render Diagnostic")
  map("<leader>rm", "expandMacro", "Rust Expand Macro")
  map("<leader>rc", "openCargo", "Rust Open Cargo.toml")
  map("<leader>rp", "parentModule", "Rust Parent Module")
  map("<leader>ro", "openDocs", "Rust Open docs.rs")
  map("<leader>rj", "joinLines", "Rust Join Lines")
end

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    -- A filetype plugin: it loads itself on the first Rust buffer
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          -- ~/.cargo/bin/rust-analyzer is a rustup shim and the component is
          -- NOT installed ("Unknown binary 'rust-analyzer'"), so the bare name
          -- must not win the PATH lookup -- point at Mason's binary.
          cmd = { mason .. "/bin/rust-analyzer" },
          -- Runs after the shared LspAttach handler in lsp.lua, so K here wins
          on_attach = function(_, bufnr)
            rust_keymaps(bufnr)
          end,
          default_settings = {
            ["rust-analyzer"] = {
              -- Syntax errors (a missing comma, an unclosed brace) come from
              -- rust-analyzer's own parser and show up as you type. Type errors
              -- come from cargo check and land on :w.
              check = { command = "clippy" },
              cargo = { buildScripts = { enable = true } },
              procMacro = { enable = true },
            },
          },
        },
        dap = {
          adapter = function()
            local ext = mason .. "/packages/codelldb/extension"
            return require("rustaceanvim.config").get_codelldb_adapter(
              ext .. "/adapter/codelldb",
              ext .. "/lldb/lib/liblldb.dylib"
            )
          end,
        },
      }
    end,
  },

  -- Cargo.toml: inline versions, upgrades, features. Its in-process LSP feeds
  -- completion/hover/code actions to blink.cmp without a dedicated source.
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
      completion = {
        crates = { enabled = true },
      },
    },
  },

  -- Minimal debugger keymaps (codelldb for Rust, debugpy for Python)
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    },
  },
}
