-- -- KANAGAWA THEME ----------------------------------------------------------------
-- require("kanagawa").setup({
-- 	compile = false,
-- 	undercurl = true,
-- 	commentStyle = { italic = true },
-- 	functionStyle = {},
-- 	keywordStyle = { italic = true },
-- 	statementStyle = { bold = true },
-- 	typeStyle = {},
-- 	transparent = true,
-- 	dimInactive = true,
-- 	terminalColors = true,
-- 	colors = {
-- 		palette = {},
-- 		theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
-- 	},
-- 	overrides = function(colors)
-- 		return {}
-- 	end,
-- 	theme = "wave",
-- 	background = {
-- 		dark = "wave",
-- 		light = "lotus",
-- 	},
--
-- vim.cmd("colorscheme kanagawa-wave")

-- GRUVBOX THEME ----------------------------------------------------------------
require("gruvbox-material").setup({
	italics = true,
	contrast = "hard",
	comments = {
		italics = true,
	},
	background = {
		transparent = true,
	},
	float = {
		force_background = false,
		background_color = nil,
	},
	signs = {
		force_background = false,
		background_color = nil,
	},
	customize = nil,
})

-- ONEDARK THEME ----------------------------------------------------------------
-- require("onedark").setup({
-- 	style = "darker",
-- })

-- SOLARIZED-OSAKA THEME ----------------------------------------------------------------
-- require("solarized-osaka").setup({
-- 	transparent = true,
-- 	terminal_colors = true,
-- 	styles = {
-- 		comments = { italic = true },
-- 		keywords = { italic = true },
-- 		functions = {},
-- 		variables = {},
-- 		sidebars = "transparent", -- normal, dark, transparent
-- 		floats = "transparent",
-- 	},
-- 	sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
-- 	day_brightness = 0.3,
-- 	hide_inactive_statusline = false,
-- 	dim_inactive = false,
-- 	lualine_bold = false,
-- })
