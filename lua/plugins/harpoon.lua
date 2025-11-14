return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()
		-- REQUIRED

		-- Добавить файл
		vim.keymap.set("n", "<leader>m", function()
			harpoon:list():add()
		end, { desc = "Add file to harpoon" })

		-- Показать список файлов
		vim.keymap.set("n", "<leader>hm", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon menu" })

		-- Переключение между файлами
		vim.keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon file 1" })
		vim.keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon file 2" })
		vim.keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon file 3" })
		vim.keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon file 4" })
		vim.keymap.set("n", "<leader>5", function()
			harpoon:list():select(5)
		end, { desc = "Harpoon file 5" })
	end,
}
