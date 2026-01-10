-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Auto-create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Reset cursor on exit
vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        vim.cmd("set guicursor=a:ver25-blinkon1")
    end,
})
