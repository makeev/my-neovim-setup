return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup{
      options = {
        mode = "tabs", -- Режим табов вместо буферов
        themable = true,
        numbers = "ordinal", -- Показывать номера табов
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
    }
  end,
}

