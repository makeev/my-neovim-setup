return {
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup({})

      -- Функция для определения темы macOS
      local function get_system_appearance()
        local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          return result:match("Dark") and "dark" or "light"
        end
        return "light"
      end

      local appearance = get_system_appearance()
      if appearance == "dark" then
        vim.cmd('colorscheme github_dark')
      else
        vim.cmd('colorscheme github_light')
      end
    end,
  },
  { "catppuccin/nvim", name = "catppuccin" }
}

