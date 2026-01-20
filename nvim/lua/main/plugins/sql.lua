return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = false },
			{ "kristijanhusak/vim-dadbod-completion" },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "sql",
				callback = function()
					vim.bo.omnifunc = "vim_dadbod_completion#omni"

					vim.schedule(function()
						vim.cmd("DBUIFindBuffer")
					end)
				end,
			})
		end,
	},
}
