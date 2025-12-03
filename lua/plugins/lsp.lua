return {
	-- Mason для управления LSP серверами
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},

	-- Mason-lspconfig для интеграции Mason и lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"basedpyright", -- форк pyright с code actions для импортов
					"ruff",
					"lua_ls",
					"stylua",
					"ts_ls", -- TypeScript/JavaScript
					"gopls", -- Go
				},
				automatic_installation = true,
			})
		end,
	},

	-- LSP конфигурация (новый API vim.lsp.config)
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- Общая функция on_attach для всех LSP серверов
			-- Уменьшите задержку для CursorHold (по умолчанию 4000ms)
			vim.opt.updatetime = 250
			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true }

				-- Добавляем подсветку переменных
				if client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
					vim.api.nvim_create_autocmd("CursorHold", {
						buffer = bufnr,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd("CursorMoved", {
						buffer = bufnr,
						callback = vim.lsp.buf.clear_references,
					})
				end

				-- Горячие клавиши
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set(
					"n",
					"<leader>rn",
					vim.lsp.buf.rename,
					{ buffer = bufnr, silent = true, desc = "LSP Rename" }
				)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-m>", vim.lsp.buf.code_action, opts)
				-- Auto Import - фильтруем code actions только для импортов (basedpyright)
				vim.keymap.set("n", "<leader>ci", function()
					vim.lsp.buf.code_action({
						filter = function(action)
							return action.kind and action.kind:match("quickfix") and action.title:lower():match("import")
						end,
						apply = true, -- автоматически применить если один вариант
					})
				end, { buffer = bufnr, silent = true, desc = "Auto Import" })
			end

			-- Настройка capabilities для автодополнения
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Установка правильной кодировки позиций (UTF-8 приоритет для ruff)
			capabilities.general = capabilities.general or {}
			capabilities.general.positionEncodings = { "utf-8", "utf-16" }

			-- Попытка использовать blink.cmp capabilities если доступно
			local has_blink, blink = pcall(require, "blink.cmp")
			if has_blink then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end

			-- НОВЫЙ API: vim.lsp.config вместо require('lspconfig')

			-- Basedpyright - форк pyright с code actions для импортов
			vim.lsp.config.basedpyright = {
				cmd = { "basedpyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace", -- анализ всего workspace для полноценных автоимпортов
							autoImportCompletions = true, -- автоимпорты в автокомплите
						},
					},
				},
			}

			-- Ruff для линтинга и форматирования
			vim.lsp.config.ruff = {
				cmd = { "ruff", "server" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "ruff.toml", ".git" },
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Отключаем лишние capabilities у ruff - оставляем только линтинг
					client.server_capabilities.hoverProvider = false
					client.server_capabilities.renameProvider = false
					client.server_capabilities.definitionProvider = false
					on_attach(client, bufnr)
				end,
			}

			-- Lua LS для конфигурации Neovim
			vim.lsp.config.lua_ls = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}

			-- TypeScript/JavaScript
			vim.lsp.config.ts_ls = {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			}

			-- Go
			vim.lsp.config.gopls = {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			}

			-- Включаем LSP серверы
			vim.lsp.enable({ "basedpyright", "ruff", "lua_ls", "ts_ls", "gopls" })

			-- Настройка диагностики
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					source = "if_many",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = " ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					source = "always",
					border = "rounded",
				},
			})
		end,
	},
}
