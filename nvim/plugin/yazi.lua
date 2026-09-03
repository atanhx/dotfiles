require("yazi").setup({
	open_for_directories = false,
	keymaps = {
		show_help = "<f1>",
	},
})

vim.keymap.set({ "n", "v" }, "<leader>-", "<cmd>Yazi<cr>", { desc = "Yazi: open at current file / folder" })
vim.keymap.set({ "n", "v" }, "<leader>yy", "<cmd>Yazi<cr>", { desc = "Yazi: open at current file" })
vim.keymap.set("n", "<leader>yc", "<cmd>Yazi cwd<cr>", { desc = "Yazi: open at working directory" })
vim.keymap.set("n", "<c-up>", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })
