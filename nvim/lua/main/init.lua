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
