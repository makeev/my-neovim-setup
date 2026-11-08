return {
  'akinsho/bufferline.nvim',
  version = "*",
  event = "VeryLazy",
  dependencies = 'nvim-tree/nvim-web-devicons',
  -- `opts` rather than a config() that calls setup() itself, so other specs
  -- can extend it (catppuccin adds its highlights in theme.lua)
  opts = {
    options = {
      mode = "tabs", -- tabs mode instead of buffers
      themable = true,
      numbers = "ordinal", -- show tab numbers
      close_command = "tabclose %d",
      right_mouse_command = "tabclose %d",
      left_mouse_command = "tabn %d",
      indicator = {
        icon = '▎',
        style = 'icon',
      },
      buffer_close_icon = '󰅖',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      separator_style = "slant",
      always_show_bufferline = true,
      show_tab_indicators = true,
      color_icons = true,
    },
  },
}
