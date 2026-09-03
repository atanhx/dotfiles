local status, bufferline = pcall(require, "bufferline")
if not status then
	return
end

bufferline.setup({
	options = {
		mode = "buffers",
		style_preset = bufferline.style_preset.default,
		themable = true,
		numbers = "none",
		close_command = function(bufnr)
			if _G.Snacks and _G.Snacks.bufdelete then
				_G.Snacks.bufdelete(bufnr)
			else
				vim.cmd("bdelete! " .. bufnr)
			end
		end,
		right_mouse_command = function(bufnr)
			if _G.Snacks and _G.Snacks.bufdelete then
				_G.Snacks.bufdelete(bufnr)
			else
				vim.cmd("bdelete! " .. bufnr)
			end
		end,
		left_mouse_command = "buffer %d",
		middle_mouse_command = function(bufnr)
			if _G.Snacks and _G.Snacks.bufdelete then
				_G.Snacks.bufdelete(bufnr)
			else
				vim.cmd("bdelete! " .. bufnr)
			end
		end,
		indicator = {
			icon = "▎",
			style = "icon",
		},
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 30,
		max_prefix_length = 30,
		tab_size = 15,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "Directory",
				text_align = "left",
				separator = true,
			},
		},
		color_icons = true,
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = false,
		show_tab_indicators = true,
		persist_buffer_sort = true,
		separator_style = "thin",
		enforce_regular_tabs = false,
		always_show_bufferline = true,
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		custom_areas = {
			right = function()
				local result = {}
				table.insert(result, {
					text = "  ",
					on_click = function()
						vim.cmd("enew")
					end,
				})
				return result
			end,
		},
	},
})

vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "Close buffers to right" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close buffers to left" })

