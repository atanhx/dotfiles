return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"vimdoc",
				"javascript",
				"typescript",
				"c",
				"lua",
				"rust",
				"jsdoc",
				"bash",
				"python",
				"json",
				"yaml",
				"html",
				"css",
				"cpp",
			},

			sync_install = true,

			auto_install = true,

			indent = {
				enable = true,
			},

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "markdown" },
			},
		})

		local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		treesitter_parser_config.templ = {
			install_info = {
				url = "https://github.com/vrischmann/tree-sitter-templ.git",
				files = { "src/parser.c", "src/scanner.c" },
				branch = "master",
			},
		}
	end,
}

