return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local function terminal_status()
			local terms = { "Terminal 1", "Terminal 2", "Terminal 3" }
			local active_terms = ""

			for _, name in ipairs(terms) do
				local buf = vim.fn.bufnr(name)
				if buf ~= -1 and vim.api.nvim_buf_is_valid(buf) then
					local num = name:match("%d+")
					active_terms = active_terms .. num .. " "
				end
			end

			if active_terms ~= "" then
				return " " .. active_terms
			end
			return ""
		end
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = true,
				refresh = {
					statusline = 100,
					tabline = 100,
					winbar = 100,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {
					{
						terminal_status,
						color = { fg = "#ff9e64", gui = "bold" },
					},
					"encoding",
					"filetype",
				},
				lualine_y = {},
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		})
	end,
}
