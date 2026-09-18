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
		{ "<leader>tl", desc = "Pick a terminal" },
		{ "<M-,>", desc = "Focus previous terminal" },
		{ "<M-.>", desc = "Focus next terminal" },
	},
	config = function()
		require("toggleterm").setup({
			size = 15,
			-- No open_mapping: <C-t>/<M-t> are bound below to a toggle that
			-- hides and restores the whole panel, not just one terminal.
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

		-- The terminal panel holds every terminal you have opened, stacked at
		-- the bottom. Showing it restores all of them, so hiding the panel and
		-- then asking for another terminal brings the earlier ones back too.
		local function all_terminals()
			return require("toggleterm.terminal").get_all()
		end

		local function open_terminals()
			return vim.tbl_filter(function(term)
				return term:is_open()
			end, all_terminals())
		end

		---@param focus_id number? terminal to create if missing, and focus
		function _G.ShowTerminalPanel(focus_id)
			local terminal = require("toggleterm.terminal")
			-- get_or_create_term() only builds the object; a terminal joins the
			-- registry that get_all() reads when it is first opened. So hold on
			-- to it here rather than looking it up again below.
			local target = focus_id and terminal.get_or_create_term(focus_id) or nil
			for _, term in ipairs(all_terminals()) do
				if not term:is_open() then
					term:open()
				end
			end
			if target then
				if not target:is_open() then
					target:open()
				end
				target:focus()
			end
		end

		-- Hide the panel if any of it is showing, otherwise bring it all back.
		function _G.ToggleTerminalPanel()
			local open = open_terminals()
			if #open > 0 then
				for _, term in ipairs(open) do
					term:close()
				end
			else
				_G.ShowTerminalPanel(#all_terminals() == 0 and 1 or nil)
			end
		end

		-- <C-t>/<M-t> toggle the panel; a count still targets one terminal,
		-- so 2<C-t> adds terminal 2 to the panel and focuses it.
		for _, lhs in ipairs({ "<C-t>", "<M-t>" }) do
			vim.keymap.set("n", lhs, function()
				local count = vim.v.count
				if count > 0 then
					_G.ShowTerminalPanel(count)
				else
					_G.ToggleTerminalPanel()
				end
			end, { silent = true, desc = "Toggle terminal panel" })

			vim.keymap.set("t", lhs, function()
				_G.ToggleTerminalPanel()
			end, { silent = true, desc = "Toggle terminal panel" })

			vim.keymap.set("i", lhs, function()
				vim.cmd("stopinsert")
				_G.ToggleTerminalPanel()
			end, { silent = true, desc = "Toggle terminal panel" })
		end

		-- Terminals 1, 2, 3: add to the panel (restoring the rest) and focus
		for id = 1, 3 do
			vim.keymap.set("n", "<leader>t" .. id, function()
				_G.ShowTerminalPanel(id)
			end, { silent = true, desc = "Terminal " .. id })
		end

		-- Move the focus between the terminals on screen; nothing is closed
		function _G.FocusTerminal(step)
			local open = open_terminals() -- get_all() sorts by id
			if #open == 0 then
				return _G.ShowTerminalPanel(1)
			end
			local current = require("toggleterm.terminal").get_focused_id()
			local index = 1
			for i, term in ipairs(open) do
				if term.id == current then
					index = i
					break
				end
			end
			open[(index - 1 + step) % #open + 1]:focus()
		end

		vim.keymap.set({ "n", "t" }, "<M-.>", function()
			_G.FocusTerminal(1)
		end, { silent = true, desc = "Focus next terminal" })

		vim.keymap.set({ "n", "t" }, "<M-,>", function()
			_G.FocusTerminal(-1)
		end, { silent = true, desc = "Focus previous terminal" })

		-- Picker over the existing terminals
		vim.keymap.set("n", "<leader>tl", function()
			local terms = all_terminals()
			if #terms == 0 then
				return _G.ShowTerminalPanel(1)
			end
			vim.ui.select(terms, {
				prompt = "Terminal: ",
				format_item = function(term)
					return term.id .. ": " .. term:_display_name()
				end,
			}, function(term)
				if term then
					_G.ShowTerminalPanel(term.id)
				end
			end)
		end, { silent = true, desc = "Pick a terminal" })
	end,
}
