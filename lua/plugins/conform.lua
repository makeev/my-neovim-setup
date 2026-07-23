return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo", "Format" },
	keys = {
		{
			"<leader>p",
			function()
				require("conform").format({ lsp_format = "fallback" })
			end,
			mode = { "n", "v" },
			desc = "Format",
		},
	},
	opts = {
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
	},
	config = function(_, opts)
		require("conform").setup(opts)

		-- :Format, with optional range support
		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			-- `lsp_fallback = true` is the deprecated spelling of `lsp_format = "fallback"`
			require("conform").format({ async = true, lsp_format = "fallback", range = range })
		end, { range = true })
	end,
}
