-- Light/dark theme switching.
--
-- Nvim 0.12 queries the terminal for its background colour (OSC 11) and keeps
-- `vim.o.background` in sync on its own, so there is no need to shell out to
-- `defaults read -g AppleInterfaceStyle` (~28ms per call) on a 30s timer.
-- Reacting to `OptionSet background` is free and switches instantly.
local function colorscheme_for(background)
  return background == "dark" and "catppuccin-mocha" or "github_light"
end

---@param background? string defaults to the current 'background'
local function apply_theme(background)
  local want = colorscheme_for(background or vim.o.background)
  if vim.g.colors_name ~= want then
    -- `hi clear` first, which also unlets g:colors_name. The incoming scheme
    -- sets 'background' while loading, and as long as the old name is set
    -- Nvim reloads the *old* scheme right in the middle of the new one.
    vim.cmd.highlight("clear")
    vim.cmd.colorscheme(want)
  end
end

-- Latest 'background' value waiting for the scheduled switch, if any
local pending_background

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
        -- Switch on the next tick, once, to the last value set. Setting
        -- 'background' makes Nvim reload the current scheme, which may set it
        -- again (github_light forces "light"; Nvim then restores the requested
        -- value), so this fires several times per change, re-entrantly and
        -- mid-load. Switching inline there also ran outside `nested`, so no
        -- ColorScheme autocmd (bufferline, snacks indent colours, init.lua's
        -- whitespace colours) fired on a switch.
        callback = function()
          local scheduled = pending_background ~= nil
          pending_background = vim.v.option_new
          if not scheduled then
            vim.schedule(function()
              local background = pending_background
              pending_background = nil
              apply_theme(background)
            end)
          end
        end,
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
          -- A function, not a table: bufferline calls it again on every
          -- ColorScheme, so the check follows light/dark switches instead of
          -- being frozen to whatever theme was active when bufferline loaded.
          -- {} keeps bufferline's own colours derived from other themes.
          opts.highlights = function()
            if (vim.g.colors_name or ""):find("catppuccin") then
              return require("catppuccin.special.bufferline").get_theme()()
            end
            return {}
          end
        end,
      },
    },
  },
}
