require("main.remap")
require("main.set")
require("main.utils.terminal")
require("main.lazy")
vim.lsp.set_log_level("debug")
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- autocmd and augroup
autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd("FileType", {
	pattern = { "sql", "mysql", "plsql" },
	callback = function()
		vim.keymap.set("n", "<leader><CR>", "<cmd>%DB<CR>", {
			buffer = true,
			desc = "Execute Entire SQL File",
		})
		vim.keymap.set("v", "<C-CR>", "<cmd>'<,'>DB<CR>", {
			buffer = true,
			desc = "Execute SQL Selection",
		})
		local run_paragraph = "vip:DB<CR>"

		vim.keymap.set("n", "<C-CR>", run_paragraph, { buffer = true, desc = "Execute Paragraph" })
		vim.keymap.set("n", "<leader>pl", run_paragraph, { buffer = true, desc = "Execute Paragraph" })
	end,
})

-- autocmd("CursorHold", {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.diagnostic.open_float(nil, {
-- 			focusable = false,
-- 			scope = "cursor",
-- 		})
-- 	end,
-- })

local cursorGrp = augroup("CursorLine", { clear = true })
autocmd({ "InsertLeave", "WinEnter" }, {
	pattern = "*",
	command = "set cursorline",
	group = cursorGrp,
})
autocmd({ "InsertEnter", "WinLeave" }, { pattern = "*", command = "set nocursorline", group = cursorGrp })
