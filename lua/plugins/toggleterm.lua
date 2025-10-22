return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 15,
			open_mapping = { "<C-t>", "<M-t>" },
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			terminal_mappings = true,
			persist_size = true,
			persist_mode = true,
			direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
			},
		})

		-- Esc для выхода из терминального режима
		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)

			-- Разворачивание/сворачивание терминала
			vim.keymap.set("t", "<C-z>", [[<Cmd>lua ToggleTerminalZoom()<CR>]], opts)
		end

		-- Функция для разворачивания/сворачивания терминала
		function _G.ToggleTerminalZoom()
			if vim.g.terminal_zoomed then
				-- Восстановить сохранённый размер
				if vim.g.terminal_saved_size then
					vim.cmd("resize " .. vim.g.terminal_saved_size)
				end
				vim.g.terminal_zoomed = false
			else
				-- Сохранить текущий размер
				vim.g.terminal_saved_size = vim.api.nvim_win_get_height(0)
				-- Развернуть на максимум
				vim.cmd("resize " .. vim.o.lines)
				vim.g.terminal_zoomed = true
			end
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		-- Маппинг для нормального режима
		vim.keymap.set("n", "<C-z>", "<Cmd>lua ToggleTerminalZoom()<CR>", { noremap = true, silent = true })
	end,
}
