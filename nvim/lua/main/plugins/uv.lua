return {
	"benomahony/uv.nvim",
	-- Optional filetype to lazy load when you open a python file
	ft = { python },
	-- Optional dependency, but recommended:
	dependencies = {
		"folke/snacks.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		picker_integration = true,
	},
}
