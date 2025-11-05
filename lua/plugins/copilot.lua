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
          accept = "<Tab>",
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

