return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		vim.opt.termguicolors = true

		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},
			filters = {
				dotfiles = false,
				-- custom = { "^.git$" },
			},
			git = {
				enable = true,
				ignore = false,
			},
			view = {
				width = 30,
			},
			-- renderer = {
			--     group_empty = true,
			--     icons = {
			--         show = {
			--             git = true,
			--             file = true,
			--             folder = true,
			--             folder_arrow = true,
			--         },
			--         glyphs = {
			--             folder = {
			--                 arrow_closed = "⏵",
			--                 arrow_open = "⏷",
			--             },
			--             git = {
			--                 unstaged = "✗",
			--                 staged = "✓",
			--                 unmerged = "⌥",
			--                 renamed = "➜",
			--                 untracked = "★",
			--                 deleted = "⊖",
			--                 ignored = "◌",
			--             },
			--         },
			--     },
			--
			-- },
			-- filters = {
			--     dotfiles = true,
			-- },
		})
	end,
}
