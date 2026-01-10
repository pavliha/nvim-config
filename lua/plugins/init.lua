return {
    -- Theme
    {
        "Mofiqul/vscode.nvim",
        priority = 1000,
        config = function()
            require("vscode").setup({
                transparent = false,
                italic_comments = true,
                disable_nvimtree_bg = true,
            })
            vim.cmd.colorscheme("vscode")
        end,
    },

    -- Dependencies
    { "nvim-lua/plenary.nvim", lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "nvim-neotest/nvim-nio", lazy = true },

    -- LSP & Completion (configs in separate files)
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },

    -- Treesitter
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

    -- File Explorer
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                git = { enable = true, ignore = false },
                view = { side = "right", width = 60 },
                update_focused_file = { enable = true, update_cwd = true },
                renderer = {
                    icons = {
                        show = { file = true, folder = true, folder_arrow = true, git = true },
                    },
                },
            })
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-file-browser.nvim",
        },
        config = function()
            local telescope = require("telescope")
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
            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "projects")
        end,
    },

    -- Projects
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                detection_methods = { "git", "pattern" },
                patterns = { ".git", "package.json", "go.mod", "Cargo.toml", "Makefile" },
                silent_chdir = true,
                scope_chdir = "global",
            })
        end,
    },

    -- Git
    { "tpope/vim-fugitive" },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
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

                    map("n", "]c", function()
                        if vim.wo.diff then return "]c" end
                        vim.schedule(function() gs.next_hunk() end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Next hunk" })

                    map("n", "[c", function()
                        if vim.wo.diff then return "[c" end
                        vim.schedule(function() gs.prev_hunk() end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Previous hunk" })

                    map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
                    map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
                    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
                    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
                end,
            })
        end,
    },
    { "sindrets/diffview.nvim" },

    -- Debugging
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require("dapui").setup()
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require("nvim-dap-virtual-text").setup()
        end,
    },

    -- Go & Templ
    { "a-h/templ", ft = "templ" },

    -- Web Development
    { "windwp/nvim-ts-autotag" },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    },

    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 20,
                open_mapping = [[<c-\>]],
                direction = "float",
                float_opts = { border = "curved" },
            })
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- Editor utilities
    {
        "NumToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({ check_ts = true })
        end,
    },
    { "folke/which-key.nvim", opts = {} },
    {
        "folke/trouble.nvim",
        opts = {},
    },

    -- Formatting
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics

            local sources = {
                formatting.prettier.with({ extra_filetypes = { "toml" } }),
                formatting.gofmt,
                formatting.goimports,
                formatting.clang_format,
                formatting.stylua,
                formatting.shfmt,
            }

            if vim.fn.executable("golangci-lint") == 1 then
                table.insert(sources, diagnostics.golangci_lint)
            end

            local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

            null_ls.setup({
                sources = sources,
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end,
            })
        end,
    },
}
