return {
	"stevearc/oil.nvim",
	dependencies = { { "echasnovski/mini.icons", "nvim-tree/nvim-web-devicons", opts = {} } },
	lazy = false,
	enabled = false,
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			columns = {
				"icon",
				"size",
				"mtime",
			},
			delete_to_trash = true,
			constrain_cursor = "editable",
			watch_for_changes = true,
			keymaps = {
				["g?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["<C-t>"] = { "actions.select", opts = { tab = true } },
				["<C-p>"] = "actions.preview",
				["<C-c>"] = { "actions.close", mode = "n" },
				["<C-l>"] = "actions.refresh",
				["-"] = { "actions.parent", mode = "n" },
				["_"] = { "actions.open_cwd", mode = "n" },
				["`"] = { "actions.cd", mode = "n" },
				["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
				["gs"] = { "actions.change_sort", mode = "n" },
				["gx"] = "actions.open_external",
				["g."] = { "actions.toggle_hidden", mode = "n" },
				["g\\"] = { "actions.toggle_trash", mode = "n" },
			},
			use_default_keymaps = false,
			view_options = {
				show_hidden = true,
				natural_order = "fast",
				case_insensitive = false,
			},
			keymaps_help = {
				border = "rounded",
			},
		})
	end,
}
