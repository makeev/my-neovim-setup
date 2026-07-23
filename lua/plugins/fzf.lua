return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- VeryLazy rather than lazy=false: it still has to load itself (so that
	-- register_ui_select() takes over vim.ui.select), just not during startup.
	event = "VeryLazy",
	opts = {},
	config = function(_, opts)
		local fzf = require("fzf-lua")
		fzf.setup(opts)
		fzf.register_ui_select()
	end,
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
