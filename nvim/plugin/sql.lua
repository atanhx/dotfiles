vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"

vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	callback = function()
		vim.bo.omnifunc = "vim_dadbod_completion#omni"

		vim.schedule(function()
			pcall(vim.cmd, "DBUIFindBuffer")
		end)
	end,
})
