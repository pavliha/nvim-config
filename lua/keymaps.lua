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
