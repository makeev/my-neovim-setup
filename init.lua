require("config.lazy")
require("config.autocmds")
require('lualine').setup()

-- Line numbers
vim.opt.number = true

-- Relative line numbers (vim-like)
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Highlight the current line
vim.opt.cursorline = true

-- Don't wrap long lines
vim.opt.wrap = false

-- Don't create backup files
vim.opt.backup = false
vim.opt.swapfile = false

-- Persistent undo and smooth scrolling
vim.opt.smoothscroll = true
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Color columns (ruler)
vim.opt.colorcolumn = {"80", "120"}

-- Auto-reload files changed outside Neovim
vim.opt.autoread = true

-- termguicolors is enabled by default since Nvim 0.10+

-- Disable the laggy matching-paren highlight
vim.g.loaded_matchparen = 1

vim.opt.list = false
vim.opt.listchars = {
    tab = '→ ',
    trail = '•',
    extends = '⟩',
    precedes = '⟨',
    nbsp = '␣',
		space = '·',
}

-- Show invisible characters only while in Visual mode
vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = '*:[vV\x16]*', -- Entering Visual, Visual Line, or Visual Block
    callback = function()
        vim.opt.list = true
    end,
})

vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = '[vV\x16]*:*', -- Leaving Visual mode
    callback = function()
        vim.opt.list = false
    end,
})

-- Colors for invisible characters
vim.cmd([[
    highlight Whitespace guifg=#3b4261 gui=NONE
    highlight NonText guifg=#3b4261 gui=NONE
]])
