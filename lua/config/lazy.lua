-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- Установить leader клавишу на пробел
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Перемещение между окнами
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Перейти в левое окно" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Перейти в нижнее окно" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Перейти в верхнее окно" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Перейти в правое окно" })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
