return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = {
			enabled = true,
			border = "rounded",
		},
		select = {
			enabled = true,
			backend = { "builtin" },
			builtin = {
				border = "rounded",
				relative = "cursor",
				buf_options = {
					modifiable = true,
				},
			},
		},
	},
}
