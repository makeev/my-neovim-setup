return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	opts = {},
	keys = {
    { "<leader><leader>", "<cmd>FzfLua builtin<cr>", desc = "FzfLua Menu" },
		{ "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
		{ "<leader>f", "<cmd>FzfLua files<cr>", desc = "Find Files (cwd)" },
		{ "<leader>g", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
		{ "<leader>R", "<cmd>FzfLua oldfiles cwd_only=true<cr>", desc = "Recent Files" },
		{
			"<leader>s",
			function()
				require("fzf-lua").lsp_live_workspace_symbols()
			end,
			desc = "Goto Symbol (Workspace)",
		},
	},
}
