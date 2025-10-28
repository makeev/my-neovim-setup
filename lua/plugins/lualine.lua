return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local opts = {
			options = {
				theme = "auto",
				-- disabled_filetypes = { statusline = { "neo-tree" } },
			},
			extensions = { "neo-tree", "lazy", "fzf", "trouble" },
		}

		return opts
	end,
}
