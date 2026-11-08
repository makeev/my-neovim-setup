return {
  -- NOTE: python/ninja/rst parsers live in the central list in treesitter.lua.
  -- The `main` branch ignores `opts.ensure_installed`, so extending it here
  -- had no effect.

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
        callback = function(args)
          -- Run the linter only for Python files
          if vim.bo[args.buf].filetype ~= "python" then
            return
          end
          -- mypy usually lives in the project's venv. Outside one it is not on
          -- PATH, and nvim-lint would raise "Error running mypy: ENOENT" on
          -- every save. :Lint still runs it unconditionally.
          if vim.fn.executable(lint.linters.mypy.cmd) == 1 then
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

  -- DAP integration for debugging Python
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- setup() takes a Python interpreter (or "uv"), not the debugpy script,
      -- and debugpy is installed neither globally nor via Mason. With "uv" the
      -- adapter runs as `uv run --with debugpy python -m debugpy.adapter`, so
      -- debugpy is fetched on demand on top of the project's environment.
      require("dap-python").setup(vim.fn.executable("uv") == 1 and "uv" or "python3")
    end,
  },
}

