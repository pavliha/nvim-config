vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

require("lazy").setup({
    -- Theme
    { "Mofiqul/vscode.nvim" },
    { "nvim-neotest/nvim-nio" },
    { "rcarriga/nvim-dap-ui" },
    -- LSP and Autocompletion
    { "neovim/nvim-lspconfig" }, -- LSP configuration
    { "hrsh7th/nvim-cmp" },      -- Autocompletion
    { "hrsh7th/cmp-nvim-lsp" },  -- LSP source for autocompletion
    { "L3MON4D3/LuaSnip" },      -- Snippets
    { "saadparwaiz1/cmp_luasnip" }, -- Snippet completions

    -- Syntax Highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- File Explorer
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

    -- Git Integration
    { "tpope/vim-fugitive" },
    { "lewis6991/gitsigns.nvim" },

    -- Debugging
    { "mfussenegger/nvim-dap" }, -- Debug Adapter Protocol
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
    { "theHamsta/nvim-dap-virtual-text" },

    -- Go Development
    { "fatih/vim-go" }, -- Go development tools

    -- Web Development
    { "windwp/nvim-ts-autotag" }, -- Auto close and rename HTML tags
    { "norcalli/nvim-colorizer.lua" }, -- Color highlight for CSS

    -- Terminal Integration
    { "akinsho/toggleterm.nvim", version = "*" },

    -- Formatting and Linting
    { "jose-elias-alvarez/null-ls.nvim" }, -- Integrates with external formatters and linters

    -- Additional Utilities
    { "nvim-lualine/lualine.nvim" }, -- Statusline
    { "tpope/vim-commentary" },
    { "lukas-reineke/indent-blankline.nvim" },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "ThePrimeagen/git-worktree.nvim" },
})

-- Configure LSP for C (clangd)
local lspconfig = require("lspconfig")
lspconfig.clangd.setup({
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
    on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        -- Keybindings
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    end,
})

require("ibl").setup({
    indent = {
        char = "│", -- or another character you prefer
    },
    scope = {
        enabled = true, -- Enable showing indentation scope
        show_start = true, -- Show the start of the scope
        show_end = false, -- Optionally show the end of the scope
    },
})

-- Configure LSP for Go (gopls)
lspconfig.gopls.setup({
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
    on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    end,
})

-- Treesitter Configuration
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "lua", "go", "html", "css", "javascript", "typescript" },
    highlight = { enable = true },
    autotag = { enable = true },
})

-- File Explorer Configuration
require("nvim-tree").setup({
    git = {
        enable = true,
        ignore = false,
    },
    view = {
        side = "right",
        width = 60,
    },
    update_cwd = true,
    renderer = {
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
        },
    },
})

-- Keybinding to toggle nvim-tree
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Load the VS Code theme
vim.cmd.colorscheme("vscode")

-- VS Code theme customization
require("vscode").setup({
    transparent = false,
    italic_comments = true,
})

-- Debugging Configuration
require("dapui").setup()
require("nvim-dap-virtual-text").setup()

-- Terminal Configuration
require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    direction = "float",
})

-- Indentation Guides

-- Statusline Configuration
require("lualine").setup({
    options = {
        theme = "vscode",
    },
})

require("telescope").load_extension("git_worktree")
vim.api.nvim_set_keymap("n", "<leader>gh", ":Telescope git_commits<CR>", { noremap = true, silent = true })

-- Formatting and Linting Configuration
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.eslint,
    },
})

vim.o.background = "dark"
vim.o.number = true
vim.o.scrolloff = 5

-- Enable auto-indentation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20"
vim.o.scrolloff = 0
vim.o.sidescrolloff = 0
vim.o.virtualedit = "onemore"
