return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	opts = {
		-- dir = vim.fn.expand(vim.fn.getcwd() .. "/.ide/"), -- сохранение сессий в папку .ide
		options = { "buffers", "curdir", "tabpages", "winsize" }, -- что сохранять
		need = 1, -- минимальное количество открытых буферов для сохранения сессии
	},
	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Restore Session",
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore Last Session",
		},
		{
			"<leader>qS",
			function()
				require("persistence").select()
			end,
			desc = "Select Session to Restore",
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Don't Save Current Session",
		},
	},
}
