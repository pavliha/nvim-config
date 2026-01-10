-- Disable netrw (must be before plugins load)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Leader key (must be before plugins)
vim.g.mapleader = " "

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.synmaxcol = 200

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Display
vim.o.background = "dark"
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.wrap = false

-- Indentation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

-- Splits
vim.o.splitbelow = true
vim.o.splitright = true

-- Files
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undolevels = 10000

-- Misc
vim.o.hidden = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noselect"
vim.o.virtualedit = "onemore"

-- Cursor
vim.opt.guicursor = {
    "n-v-c:block",
    "i-ci-ve:ver25",
    "r-cr:hor20",
    "o:hor50",
    "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
    "sm:block-blinkwait175-blinkoff150-blinkon175",
}
