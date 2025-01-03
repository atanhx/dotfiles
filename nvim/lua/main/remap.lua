vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.api.nvim_set_keymap("n", "<M-p>", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle NvimTree" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open quickfix list with diagnostics" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down (visual mode)" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up (visual mode)" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Move line down and keep cursor position" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and keep cursor in middle" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and keep cursor in middle" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Go to next search result and keep cursor in middle" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Go to previous search result and keep cursor in middle" })
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "Restart LSP server" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting clipboard (visual mode)" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without copying" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "<C-s>", "<Esc>", { desc = "Exit insert mode (alternative)" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Do nothing (disable Q)" })
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Start tmux sessionizer" })
vim.keymap.set("n", "<leader>pf", vim.lsp.buf.format, { desc = "Format current buffer with LSP" })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Go to next quickfix item" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Go to previous quickfix item" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Go to next location list item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Go to previous location list item" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word under cursor" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "Reloads NVIM with :so" })
