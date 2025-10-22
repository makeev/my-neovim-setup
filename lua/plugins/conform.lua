return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				json = { "prettier" },
				javascript = { "prettier" },
				python = { "ruff" },
				lua = { "stylua" },
				typescript = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				markdown = { "prettier" },
			},
			format_on_save = false,

			-- :Format
			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_fallback = true, range = range })
			end, { range = true }),

			-- Горячая клавиша
			vim.keymap.set({ "n", "v" }, "<leader>p", function()
				require("conform").format({ lsp_fallback = true })
			end, { desc = "Format" }),
			-- format_on_save = {
			-- 	timeout_ms = 500,
			-- 	lsp_fallback = true,
			-- },
		})
	end,
}
