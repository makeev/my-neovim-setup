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
      nes = { enabled = false, auto_trigger = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)

      -- Умный Tab с приоритетом: snippet -> copilot -> tab
      -- Проверка blink.is_visible() удалена - она блокировала copilot при показе ghost text
      vim.keymap.set("i", "<Tab>", function()
        -- 1. Проверяем snippet navigation (если активен snippet)
        local blink_ok, blink = pcall(require, "blink.cmp")
        if blink_ok then
          local snippet_ok, did_jump = pcall(blink.snippet_forward)
          if snippet_ok and did_jump then return end
        end

        -- 2. Проверяем copilot suggestion
        local suggestion_ok, suggestion = pcall(require, "copilot.suggestion")
        if suggestion_ok and suggestion.is_visible() then
          suggestion.accept()
          return
        end

        -- 3. Вставляем Tab или пробелы
        if vim.o.expandtab then
          return string.rep(" ", vim.o.shiftwidth)
        else
          return "\t"
        end
      end, { expr = true, silent = true, desc = "Snippet forward, accept Copilot, or insert tab" })

      -- Shift-Tab для навигации назад по snippet
      vim.keymap.set("i", "<S-Tab>", function()
        local blink_ok, blink = pcall(require, "blink.cmp")
        if blink_ok then
          local snippet_ok, did_jump = pcall(blink.snippet_backward)
          if snippet_ok and did_jump then return end
        end

        -- Fallback: обычный Shift-Tab behavior (dedent)
        return "\t"
      end, { expr = true, silent = true, desc = "Snippet backward" })
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

