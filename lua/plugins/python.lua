return {
  -- Treesitter для Python синтаксиса
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "python", "ninja", "rst" })
    end,
  },

  -- nvim-lint для mypy и других линтеров
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Настройка линтеров для разных типов файлов
      lint.linters_by_ft = {
        python = { "mypy" },
      }

      -- Настройка mypy для работы с проектами
      lint.linters.mypy.args = {
        "--show-column-numbers",
        "--show-error-end",
        "--hide-error-codes",
        "--hide-error-context",
        "--no-color-output",
        "--no-error-summary",
        "--no-pretty",
      }

      -- Автоматический запуск линтера только при сохранении (уменьшаем нагрузку)
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = lint_augroup,
        callback = function()
          -- Запускаем линтер только для Python файлов
          if vim.bo.filetype == "python" then
            lint.try_lint()
          end
        end,
      })

      -- Команда для ручного запуска линтера
      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },

  -- Настройки для Python LSP серверов (pyright и ruff_lsp)
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Эти серверы уже настроены в lsp.lua через mason-lspconfig
      -- Здесь можем добавить дополнительные Python-специфичные настройки
      return {}
    end,
  },

  -- Интеграция с DAP для отладки Python
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- Попытка найти debugpy в системе
      local debugpy_path = vim.fn.exepath("debugpy")
      if debugpy_path ~= "" then
        require("dap-python").setup(debugpy_path)
      end
    end,
  },
}

