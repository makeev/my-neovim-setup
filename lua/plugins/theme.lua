return {
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
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
			})

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

			-- Функция для применения темы
			local function apply_theme()
				local appearance = get_system_appearance()
				local new_colorscheme = appearance == "dark" and "catppuccin-mocha" or "catppuccin-latte"

				if vim.g.colors_name ~= new_colorscheme then
					vim.cmd("colorscheme " .. new_colorscheme)
				end
			end

			-- Применяем тему при запуске
			apply_theme()

			-- Автоматически проверяем тему каждые 5 секунд
			local timer = vim.loop.new_timer()
			timer:start(
				0,
				5000,
				vim.schedule_wrap(function()
					apply_theme()
				end)
			)
		end,
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
