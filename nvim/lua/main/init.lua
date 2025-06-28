require("main.remap")
require("main.set")
require("main.lazy")

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

local cursorGrp = augroup("CursorLine", { clear = true })
autocmd({ "InsertLeave", "WinEnter" }, {
	pattern = "*",
	command = "set cursorline",
	group = cursorGrp,
})
autocmd({ "InsertEnter", "WinLeave" }, { pattern = "*", command = "set nocursorline", group = cursorGrp })
