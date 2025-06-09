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

-- Safe require function
local function safe_require(module)
    local ok, result = pcall(require, module)
    if not ok then
        vim.notify("Failed to load " .. module .. ": " .. result, vim.log.levels.ERROR)
        return nil
    end
    return result
end

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

    -- Syntax Highlighting (Updated)
    { 
        "nvim-treesitter/nvim-treesitter", 
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "cpp", "lua", "go", "html", "css", "javascript", "typescript", "templ" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                autotag = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
            })
        end,
    },

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
    { "a-h/templ", ft = "templ" }, -- Templ template support

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
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
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

-- Configure autocompletion (with safety check)
local cmp = safe_require("cmp")
local luasnip = safe_require("luasnip")

if cmp and luasnip then
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
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
        }, {
            { name = "buffer" },
            { name = "path" },
        }),
    })
end

-- Configure LSP for C (clangd)
local lspconfig = safe_require("lspconfig")
if lspconfig then
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
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
            },
        },
        on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end,
    })

    -- Configure LSP for Templ
    lspconfig.templ.setup({
        cmd = { "templ", "lsp" },
        filetypes = { "templ" },
        root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
        on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end,
    })
end

-- Telescope Configuration
local telescope = safe_require("telescope")
if telescope then
    telescope.setup({
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
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
                case_mode = "smart_case",
            },
        },
    })

    -- Load extensions safely
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "git_worktree")
end

-- File Explorer Configuration
local nvim_tree = safe_require("nvim-tree")
if nvim_tree then
    -- Disable netrw at startup
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvim_tree.setup({
        git = {
            enable = true,
            ignore = false,
        },
        view = {
            side = "right",
            width = 60,
        },
        update_focused_file = {
            enable = true,
            update_cwd = true,
        },
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
end

-- Load the VS Code theme
local vscode = safe_require("vscode")
if vscode then
    vscode.setup({
        transparent = false,
        italic_comments = true,
        disable_nvimtree_bg = true,
    })
    vim.cmd.colorscheme("vscode")
else
    -- Fallback to default colorscheme
    vim.cmd.colorscheme("default")
end

-- Git Signs Configuration
local gitsigns = safe_require("gitsigns")
if gitsigns then
    gitsigns.setup({
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
            interval = 1000,
            follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false,
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
end

-- Debugging Configuration
local dapui = safe_require("dapui")
if dapui then
    dapui.setup()
end

local dap_virtual_text = safe_require("nvim-dap-virtual-text")
if dap_virtual_text then
    dap_virtual_text.setup()
end

-- Terminal Configuration
local toggleterm = safe_require("toggleterm")
if toggleterm then
    toggleterm.setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
            border = "curved",
            winblend = 0,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
    })
end

-- Statusline Configuration
local lualine = safe_require("lualine")
if lualine then
    lualine.setup({
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "", right = ""},
            section_separators = { left = "", right = ""},
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    })
end

-- Comment Configuration (Simplified)
local comment = safe_require("Comment")
if comment then
    comment.setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
            line = 'gcc',
            block = 'gbc',
        },
        opleader = {
            line = 'gc',
            block = 'gb',
        },
        extra = {
            above = 'gcO',
            below = 'gco',
            eol = 'gcA',
        },
        mappings = {
            basic = true,
            extra = true,
        },
    })
end

-- Auto pairs Configuration
local autopairs = safe_require("nvim-autopairs")
if autopairs then
    autopairs.setup({
        check_ts = true,
        ts_config = {
            lua = {'string'},
            javascript = {'template_string'},
            java = false,
        }
    })
    
    -- Integration with nvim-cmp
    if cmp then
        local cmp_autopairs = safe_require("nvim-autopairs.completion.cmp")
        if cmp_autopairs then
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end
    end
end

-- Which-key Configuration
local which_key = safe_require("which-key")
if which_key then
    which_key.setup({
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = true,
                suggestions = 20,
            },
            presets = {
                operators = true,
                motions = true,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
        },
    })
end

-- Trouble Configuration
local trouble = safe_require("trouble")
if trouble then
    trouble.setup({
        position = "bottom",
        height = 10,
        width = 50,
        icons = true,
        mode = "workspace_diagnostics",
        fold_open = "",
        fold_closed = "",
        group = true,
        padding = true,
        action_keys = {
            close = "q",
            cancel = "<esc>",
            refresh = "r",
            jump = {"<cr>", "<tab>"},
            open_split = { "<c-x>" },
            open_vsplit = { "<c-v>" },
            open_tab = { "<c-t>" },
            jump_close = {"o"},
            toggle_mode = "m",
            toggle_preview = "P",
            hover = "K",
            preview = "p",
            close_folds = {"zM", "zm"},
            open_folds = {"zR", "zr"},
            toggle_fold = {"zA", "za"},
            previous = "k",
            next = "j"
        },
        indent_lines = true,
        auto_open = false,
        auto_close = false,
        auto_preview = true,
        auto_fold = false,
        auto_jump = {"lsp_definitions"},
        signs = {
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠"
        },
        use_diagnostic_signs = false
    })
end

-- Formatting and Linting Configuration (Updated to use none-ls)
local null_ls = safe_require("null-ls")
if null_ls then
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local sources = {
        formatting.prettier.with({
            extra_filetypes = { "toml", "solidity" },
        }),
        formatting.gofmt,
        formatting.clang_format,
    }

    -- Only add eslint if it's available
    if vim.fn.executable("eslint") == 1 then
        table.insert(sources, diagnostics.eslint)
    end

    null_ls.setup({
        debug = false,
        sources = sources,
        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end
        end,
    })
end

-- Basic Vim Settings
vim.o.background = "dark"
vim.o.number = true
vim.o.relativenumber = true        -- Show relative line numbers
vim.o.scrolloff = 8                -- Keep 8 lines visible when scrolling
vim.o.sidescrolloff = 8
vim.o.cursorline = true           -- Highlight current line
vim.o.signcolumn = "yes"          -- Always show sign column
vim.o.wrap = false                -- No line wrapping

-- Enable auto-indentation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

-- Cursor configuration
vim.opt.guicursor = {
    "n-v-c:block",
    "i-ci-ve:ver25",
    "r-cr:hor20",
    "o:hor50",
    "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
    "sm:block-blinkwait175-blinkoff150-blinkon175"
}

-- Reset cursor on exit
vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        vim.cmd("set guicursor=a:ver25-blinkon1")
    end,
})

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

-- Additional performance improvements
vim.o.hidden = true               -- Allow hidden buffers
vim.o.mouse = "a"                 -- Enable mouse support
vim.o.clipboard = "unnamedplus"   -- Use system clipboard
vim.o.completeopt = "menuone,noselect" -- Better completion experience

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
})

-- Auto-create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})
