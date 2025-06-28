return {
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_transparent_background = 1
			vim.g.gruvbox_material_enable_bold = 1
			vim.g.gruvbox_material_background = "soft"
			vim.g.gruvbox_material_palette = "mix"
			vim.g.gruvbox_material_enable_italic = true
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
}
