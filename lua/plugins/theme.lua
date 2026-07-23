-- Light/dark theme switching.
--
-- Nvim 0.12 queries the terminal for its background colour (OSC 11) and keeps
-- `vim.o.background` in sync on its own, so there is no need to shell out to
-- `defaults read -g AppleInterfaceStyle` (~28ms per call) on a 30s timer.
-- Reacting to `OptionSet background` is free and switches instantly.
local function colorscheme_for(background)
  return background == "dark" and "catppuccin-mocha" or "github_light"
end

local function apply_theme()
  local want = colorscheme_for(vim.o.background)
  if vim.g.colors_name ~= want then
    vim.cmd.colorscheme(want)
  end
end

return {
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({})

      apply_theme()

      vim.api.nvim_create_autocmd("OptionSet", {
        group = vim.api.nvim_create_augroup("theme_follow_background", { clear = true }),
        pattern = "background",
        callback = apply_theme,
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {},
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.special.bufferline").get_theme()
          end
        end,
      },
    },
  },
}
