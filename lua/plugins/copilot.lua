return {
  recommended = true,
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 150, -- задержка для снижения нагрузки при печати
        hide_during_completion = false, -- не прятать copilot при показе blink.cmp
        keymap = {
          accept = false, -- отключаем стандартный биндинг
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)

      -- Умный Tab: принимает copilot если есть предложение, иначе вставляет отступ
      vim.keymap.set("i", "<Tab>", function()
        local suggestion = require("copilot.suggestion")
        if suggestion.is_visible() then
          suggestion.accept()
        else
          -- Вставляем Tab или пробелы в зависимости от expandtab
          if vim.o.expandtab then
            return string.rep(" ", vim.o.shiftwidth)
          else
            return "\t"
          end
        end
      end, { expr = true, silent = true, desc = "Accept Copilot or insert tab" })
    end,
  },

  -- copilot-language-server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- copilot.lua only works with its own copilot lsp server
        copilot = { enabled = false },
      },
    },
  },
}

