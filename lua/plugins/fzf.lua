return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "nvim-mini/mini.icons" },
	opts = {},
	keys = {
		{ "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
		{ "<leader>f", "<cmd>FzfLua files<cr>", desc = "Find Files (cwd)" },
		{ "<leader>g", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
		{
			"<leader>s",
			function()
				require("fzf-lua").lsp_live_workspace_symbols({
					regex_filter = symbols_filter,
				})
			end,
			desc = "Goto Symbol (Workspace)",
		},
	},
}
