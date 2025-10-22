require("config.lazy")
require("config.autocmds")

-- Номера строк
vim.opt.number = true

-- Относительные vim-like номера
vim.opt.relativenumber = true

-- базовые отступы
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- подсветка текущей строки
vim.opt.cursorline = true

-- не переносить длинные строки
vim.opt.wrap = false

-- не создавать bkup файлы
vim.opt.backup = false
vim.opt.swapfile = false

-- еще какие-то настройки
vim.opt.smoothscroll = true
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- поиск
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- рулер
vim.opt.colorcolumn = {"80", "120"}

-- автоперезагрузка файлов
vim.opt.autoread = true

-- colors
vim.opt.termguicolors = true

vim.opt.list = false
vim.opt.listchars = {
    tab = '→ ',
    trail = '•',
    extends = '⟩',
    precedes = '⟨',
    nbsp = '␣',
		space = '·',
}

-- Автокоманды для включения/выключения при входе в Visual режим
vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = '*:[vV\x16]*', -- Переход в Visual, Visual Line, Visual Block
    callback = function()
        vim.opt.list = true
    end,
})

vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = '[vV\x16]*:*', -- Выход из Visual режима
    callback = function()
        vim.opt.list = false
    end,
})

-- Цвета для невидимых символов
vim.cmd([[
    highlight Whitespace guifg=#3b4261 gui=NONE
    highlight NonText guifg=#3b4261 gui=NONE
]])
