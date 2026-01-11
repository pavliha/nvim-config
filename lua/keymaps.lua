local map = vim.keymap.set

-- Essential
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resize
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Switch project" })
map("n", "<leader>fd", function()
    require("telescope.builtin").find_files({
        find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" },
        prompt_title = "Find Directories",
    })
end, { desc = "Find directories" })

-- Git
map("n", "<leader>gh", ":Telescope git_commits<CR>", { desc = "Git commits" })
map("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
map("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Git diff view" })
map("n", "<leader>gc", ":DiffviewClose<CR>", { desc = "Close diff view" })

-- File explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>o", ":NvimTreeFindFile<CR>", { desc = "Find file in explorer" })

-- Search
map("n", "<leader>/", ":nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Indenting (stay in visual mode)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move text
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Scrolling (keep centered)
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Paste without losing register
map("x", "<leader>p", [["_dP]], { desc = "Paste without losing register" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })

-- Buffers (like WebStorm tabs)
map("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bo", ":BufferLineCloseOthers<CR>", { desc = "Close other buffers" })

-- Search and replace (like WebStorm Ctrl+Shift+R)
map("n", "<leader>sr", function() require("spectre").open() end, { desc = "Search and replace" })
map("n", "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, { desc = "Search current word" })

-- Trouble diagnostics
map("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { desc = "Toggle diagnostics" })
map("n", "<leader>xq", ":Trouble quickfix toggle<CR>", { desc = "Toggle quickfix" })

-- Aerial (code outline / structure view)
map("n", "<leader>a", ":AerialToggle<CR>", { desc = "Toggle code outline" })
map("n", "{", ":AerialPrev<CR>", { desc = "Previous symbol" })
map("n", "}", ":AerialNext<CR>", { desc = "Next symbol" })

-- Lspsaga (better LSP UI)
map("n", "gh", ":Lspsaga hover_doc<CR>", { desc = "Hover doc" })
map("n", "gp", ":Lspsaga peek_definition<CR>", { desc = "Peek definition" })
map("n", "<leader>ca", ":Lspsaga code_action<CR>", { desc = "Code action" })
map("n", "<leader>rn", ":Lspsaga rename<CR>", { desc = "Rename" })
map("n", "<leader>lo", ":Lspsaga outline<CR>", { desc = "LSP outline" })

-- Harpoon (quick file bookmarks)
map("n", "<leader>ha", function() require("harpoon"):list():add() end, { desc = "Harpoon add file" })
map("n", "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, { desc = "Harpoon menu" })
map("n", "<leader>1", function() require("harpoon"):list():select(1) end, { desc = "Harpoon file 1" })
map("n", "<leader>2", function() require("harpoon"):list():select(2) end, { desc = "Harpoon file 2" })
map("n", "<leader>3", function() require("harpoon"):list():select(3) end, { desc = "Harpoon file 3" })
map("n", "<leader>4", function() require("harpoon"):list():select(4) end, { desc = "Harpoon file 4" })

-- Neotest (test runner)
map("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
map("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
map("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, { desc = "Show test output" })

-- TODO comments
map("n", "<leader>td", ":TodoTelescope<CR>", { desc = "Find TODOs" })
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous TODO" })

-- Session (persistence)
map("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session" })
map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })

-- Markdown preview
map("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { desc = "Toggle markdown preview" })
