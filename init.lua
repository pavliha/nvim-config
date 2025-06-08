-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key
vim.g.mapleader = " "

require("lazy").setup({
    -- Theme
    { "Mofiqul/vscode.nvim" },
    { "nvim-neotest/nvim-nio" },
    { "rcarriga/nvim-dap-ui" },

    -- LSP and Autocompletion
    { "neovim/nvim-lspconfig" },    -- LSP configuration
    { "hrsh7th/nvim-cmp" },         -- Autocompletion
    { "hrsh7th/cmp-nvim-lsp" },     -- LSP source for autocompletion
    { "hrsh7th/cmp-buffer" },       -- Buffer completions
    { "hrsh7th/cmp-path" },         -- Path completions
    { "L3MON4D3/LuaSnip" },         -- Snippets
    { "saadparwaiz1/cmp_luasnip" }, -- Snippet completions

    -- Syntax Highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "JoosepAlviste/nvim-ts-context-commentstring" }, -- Context-aware comments

    -- File Explorer and Navigation
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-file-browser.nvim" },

    -- Git Integration
    { "tpope/vim-fugitive" },
    { "lewis6991/gitsigns.nvim" },
    { "ThePrimeagen/git-worktree.nvim" },

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

    -- Formatting and Linting (Updated)
    { "nvimtools/none-ls.nvim" }, -- Updated replacement for null-ls

    -- Additional Utilities
    { "nvim-lualine/lualine.nvim" }, -- Statusline
    { "NumToStr/Comment.nvim" },     -- Better commenting
    { "lukas-reineke/indent-blankline.nvim" },
    { "windwp/nvim-autopairs" },     -- Auto pairs for brackets
    { "kyazdani42/nvim-web-devicons" }, -- Better icons
    { "folke/which-key.nvim" },      -- Show keybindings
    { "folke/trouble.nvim" },        -- Better diagnostics view
})

-- Performance optimizations for Raspberry Pi
vim.opt.updatetime = 250        -- Faster completion
vim.opt.timeoutlen = 300        -- Faster key sequences
vim.opt.lazyredraw = true       -- Don't redraw during macros
vim.opt.synmaxcol = 200         -- Limit syntax highlighting for long lines

-- Disable some heavy providers if performance is an issue
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Essential Key Mappings
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Telescope keybindings
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>gh", ":Telescope git_commits<CR>", { desc = "Git commits" })

-- File Explorer
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Configure autocompletion
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }),
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
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    end,
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
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    end,
})

-- Treesitter Configuration
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "lua", "go", "html", "css", "javascript", "typescript" },
    highlight = { enable = true },
    autotag = { enable = true },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
})

-- Telescope Configuration
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
        },
    },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("git_worktree")

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

-- Load the VS Code theme
vim.cmd.colorscheme("vscode")

-- VS Code theme customization
require("vscode").setup({
    transparent = false,
    italic_comments = true,
})

-- Git Signs Configuration
require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, {expr=true, desc = "Next hunk"})

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, {expr=true, desc = "Previous hunk"})

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, {desc = "Stage hunk"})
        map('n', '<leader>hr', gs.reset_hunk, {desc = "Reset hunk"})
        map('n', '<leader>hp', gs.preview_hunk, {desc = "Preview hunk"})
        map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = "Blame line"})
    end
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

-- Statusline Configuration
require("lualine").setup({
    options = {
        theme = "vscode",
    },
})

-- Comment Configuration
require("Comment").setup({
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

-- Auto pairs Configuration
require("nvim-autopairs").setup({})

-- Which-key Configuration
require("which-key").setup({})

-- Trouble Configuration
require("trouble").setup({})

-- Formatting and Linting Configuration (Updated to use none-ls)
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.clang_format,
    },
})

-- Basic Vim Settings
vim.o.background = "dark"
vim.o.number = true
vim.o.relativenumber = true        -- Show relative line numbers
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.o.cursorline = true           -- Highlight current line
vim.o.signcolumn = "yes"          -- Always show sign column

-- Enable auto-indentation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20"
vim.o.virtualedit = "onemore"

-- Search settings
vim.o.ignorecase = true           -- Case insensitive searching
vim.o.smartcase = true            -- Case sensitive if uppercase present
vim.o.hlsearch = true             -- Highlight search results
vim.o.incsearch = true            -- Show search results as you type

-- Split settings
vim.o.splitbelow = true           -- Open horizontal splits below
vim.o.splitright = true           -- Open vertical splits to the right

-- Better backup settings
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Undo settings
vim.o.undofile = true             -- Persistent undo
vim.o.undolevels = 10000          -- Maximum number of undos

-- Clear search highlighting
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Better paste
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without losing register" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })
