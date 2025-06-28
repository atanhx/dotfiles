vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open quickfix list with diagnostics" })
vim.keymap.set("n", "<leader>Q", "<cmd>wq!<CR>", { desc = "Force save and  quit" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down (visual mode)" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up (visual mode)" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Move line down and keep cursor position" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and keep cursor in middle" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and keep cursor in middle" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Go to next search result and keep cursor in middle" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Go to previous search result and keep cursor in middle" })

vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without overwriting clipboard (visual mode)" })
vim.keymap.set({ "n", "v" }, "y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>dd", '"_d', { desc = "Delete without copying" })

vim.keymap.set("n", "<C-s>", "gg<S-v>G")
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode (alternative)" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Do nothing (disable Q)" })
vim.keymap.set("n", "<leader>pf", vim.lsp.buf.format, { desc = "Format current buffer with LSP" })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Go to next quickfix item" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Go to previous quickfix item" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Go to next location list item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Go to previous location list item" })

vim.keymap.set("v", "<", "<gv", { desc = "(V) Indent to left" })
vim.keymap.set("v", ">", ">gv", { desc = "(V) Indent to right" })

vim.keymap.set("n", "hs", ":split<Return>")
vim.keymap.set("n", "vs", ":vsplit<Return>")
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize split up" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize split down" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize split left" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize split right" })

vim.keymap.set("n", "<C-t>", "<cmd>tabnew<CR>", { desc = "Create new tab" })
vim.keymap.set("n", "J", "<cmd>tabprevious<CR>", { desc = "Change to previous tab" })
vim.keymap.set("n", "K", "<cmd>tabnext<CR>", { desc = "Change to next tab" })

vim.keymap.set({ "i" }, "<C-l>", "<Right>", { desc = "Move cursor to right" })
vim.keymap.set({ "i" }, "<C-h>", "<Left>", { desc = "Move cursor to right" })

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })
