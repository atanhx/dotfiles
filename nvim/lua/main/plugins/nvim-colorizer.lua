return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = { -- set to setup table
	},
	config = function()
		require("colorizer").setup({
			user_commands = true, -- Enable all or some usercommands
			lazy_load = false, -- Lazily schedule buffer highlighting setup function
			user_default_options = {
				names = true, -- "Name" codes like Blue or red.  Added from `vim.api.nvim_get_color_map()`
				names_opts = { -- options for mutating/filtering names.
					lowercase = true, -- name:lower(), highlight `blue` and `red`
					camelcase = true, -- name, highlight `Blue` and `Red`
					uppercase = false, -- name:upper(), highlight `BLUE` and `RED`
					strip_digits = false, -- ignore names with digits,
				},
				names_custom = false, -- Custom names to be highlighted: table|function|false
				RGB = true, -- #RGB hex codes
				RGBA = true, -- #RGBA hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				AARRGGBB = true, -- 0xAARRGGBB hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS *features*:
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				tailwind = false, -- Enable tailwind colors
				tailwind_opts = { -- Options for highlighting tailwind names
					update_names = false, -- When using tailwind = 'both', update tailwind names from LSP results.  See tailwind section
				},
				sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
				mode = "background", -- Set the display mode
				virtualtext = "■",
				virtualtext_inline = false,
				virtualtext_mode = "foreground",
				always_update = true,
				hooks = {
					disable_line_highlight = false,
				},
			},
		})
	end,
}
