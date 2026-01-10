-- Load options first (includes leader key, netrw disable)
require("options")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins")

-- Load keymaps and autocmds after plugins
require("keymaps")
require("autocmds")

-- Load LSP config (uses native vim.lsp.config)
require("config.lsp")

-- Load completion config
require("config.cmp")
