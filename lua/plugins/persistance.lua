return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	opts = {
		-- dir = vim.fn.expand(vim.fn.getcwd() .. "/.ide/"), -- сохранение сессий в папку .ide
		options = { "buffers", "curdir", "tabpages", "winsize" }, -- что сохранять
		need = 1, -- минимальное количество открытых буферов для сохранения сессии
		pre_save = function()
			-- Закрыть neo-tree перед сохранением сессии
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
				if ft == "neo-tree" then
					vim.api.nvim_win_close(win, true)
				end
			end
		end,
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
