return {
	-- {
	--     "sainnhe/gruvbox-material",
	--     lazy = false,
	--     priority = 1000,
	--     config = function()
	--         vim.g.gruvbox_material_transparent_background = 2
	--         vim.g.gruvbox_material_enable_bold = 2
	--         vim.g.gruvbox_material_float_style = "bright"
	--         vim.g.gruvbox_material_background = "soft"
	--         vim.g.gruvbox_material_palette = "mix"
	--         vim.g.gruvbox_material_enable_italic = true
	--         vim.cmd.colorscheme("gruvbox-material")
	--     end,
	-- },
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = true,
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = false, -- define vim.g.terminal_color_{0,17}
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				overrides = function(colors)
					return {}
				end,
				theme = "wave",
				background = {
					dark = "wave",
					light = "lotus",
				},
			})

			vim.cmd("colorscheme kanagawa")
		end,
	},
}
