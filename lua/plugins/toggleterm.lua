return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = { "ToggleTerm", "ToggleTermToggleAll" },
	keys = {
		{ "<C-t>", desc = "Toggle terminal" },
		{ "<M-t>", desc = "Toggle terminal" },
		{ "<leader>t1", desc = "Terminal 1" },
		{ "<leader>t2", desc = "Terminal 2" },
		{ "<leader>t3", desc = "Terminal 3" },
	},
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

		-- Esc to leave terminal mode
		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)

			-- Zoom the terminal in/out
			vim.keymap.set("t", "<C-z>", [[<Cmd>lua ToggleTerminalZoom()<CR>]], opts)
		end

		-- Function to zoom the terminal in/out
		function _G.ToggleTerminalZoom()
			if vim.g.terminal_zoomed then
				-- Restore the saved size
				if vim.g.terminal_saved_size then
					vim.cmd("resize " .. vim.g.terminal_saved_size)
				end
				vim.g.terminal_zoomed = false
			else
				-- Save the current size
				vim.g.terminal_saved_size = vim.api.nvim_win_get_height(0)
				-- Expand to full height
				vim.cmd("resize " .. vim.o.lines)
				vim.g.terminal_zoomed = true
			end
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		-- Mapping for normal mode
		vim.keymap.set("n", "<C-z>", "<Cmd>lua ToggleTerminalZoom()<CR>", { noremap = true, silent = true })

		-- Function to open/focus a terminal (without closing it)
		function _G.FocusOrOpenTerminal(term_id)
			local terminals = require("toggleterm.terminal").get_all()
			for _, term in ipairs(terminals) do
				if term.id == term_id and term:is_open() then
					-- Terminal is open — focus it
					term:focus()
					return
				end
			end
			-- Terminal is not open — open it
			vim.cmd(term_id .. "ToggleTerm")
		end

		-- Mappings for terminals 1, 2, 3
		vim.keymap.set("n", "<leader>t1", "<Cmd>lua FocusOrOpenTerminal(1)<CR>", { desc = "Terminal 1" })
		vim.keymap.set("n", "<leader>t2", "<Cmd>lua FocusOrOpenTerminal(2)<CR>", { desc = "Terminal 2" })
		vim.keymap.set("n", "<leader>t3", "<Cmd>lua FocusOrOpenTerminal(3)<CR>", { desc = "Terminal 3" })
	end,
}
