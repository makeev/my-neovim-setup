return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-web-devicons",
	},
	ft = { "markdown", "codecompanion", "copilot-chat" },
	---@module "render-markdown"
	---@type render.md.UserConfig
	opts = {
		completions = { lsp = { enabled = true } },
		code = {
			sign = false,
			width = "block",
			right_pad = 1,
		},
		heading = {
			sign = false,
			icons = {},
		},
	},
	keys = {
		{ "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown render", ft = "markdown" },
	},
}
