return {
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
        debounce = 150, -- delay to reduce load while typing
        hide_during_completion = false, -- keep copilot visible when blink.cmp is showing
        keymap = {
          accept = false, -- disable the default binding
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

      -- Smart Tab with priority: snippet -> copilot -> tab
      -- The blink.is_visible() check was removed - it blocked copilot while ghost text was showing
      vim.keymap.set("i", "<Tab>", function()
        -- 1. Check snippet navigation (if a snippet is active)
        local blink_ok, blink = pcall(require, "blink.cmp")
        if blink_ok then
          local snippet_ok, did_jump = pcall(blink.snippet_forward)
          if snippet_ok and did_jump then return end
        end

        -- 2. Check for a copilot suggestion
        local suggestion_ok, suggestion = pcall(require, "copilot.suggestion")
        if suggestion_ok and suggestion.is_visible() then
          suggestion.accept()
          return
        end

        -- 3. Insert a tab or spaces
        if vim.o.expandtab then
          return string.rep(" ", vim.o.shiftwidth)
        else
          return "\t"
        end
      end, { expr = true, silent = true, desc = "Snippet forward, accept Copilot, or insert tab" })

      -- Shift-Tab to navigate backward through a snippet
      vim.keymap.set("i", "<S-Tab>", function()
        local blink_ok, blink = pcall(require, "blink.cmp")
        if blink_ok then
          local snippet_ok, did_jump = pcall(blink.snippet_backward)
          if snippet_ok and did_jump then return end
        end

        -- Fallback: default Shift-Tab behavior (dedent)
        return "\t"
      end, { expr = true, silent = true, desc = "Snippet backward" })
    end,
  },

}

