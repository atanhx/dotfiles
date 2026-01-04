local M = {}

local terminals = {}

function M.toggle_terminal(idx)
	idx = idx or 1
	local term = terminals[idx]

	if not term then
		term = { buf = -1, win = -1, job_id = -1, last_cwd = "" }
		terminals[idx] = term
	end

	local current_cwd = vim.fn.getcwd()

	if not vim.api.nvim_buf_is_valid(term.buf) then
		vim.cmd("split")
		vim.cmd("resize 15")
		vim.cmd("terminal")

		vim.api.nvim_buf_set_name(0, "Terminal " .. idx)

		term.buf = vim.api.nvim_get_current_buf()
		term.win = vim.api.nvim_get_current_win()
		term.last_cwd = current_cwd
		term.job_id = vim.bo.channel

		vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { buffer = term.buf })
		vim.cmd("startinsert")
		return
	end

	if term.last_cwd ~= current_cwd then
		vim.api.nvim_chan_send(term.job_id, "cd " .. current_cwd .. "\r")
		-- Optional: Clear term buffer
		-- vim.api.nvim_chan_send(term.job_id, "clear\r")

		term.last_cwd = current_cwd
		print("Terminal " .. idx .. " moved to: " .. current_cwd)
	end

	local win_handle = vim.fn.bufwinnr(term.buf)

	if win_handle ~= -1 then
		local win_id = vim.fn.win_getid(win_handle)
		vim.api.nvim_win_hide(win_id)
	else
		vim.cmd("split")
		vim.cmd("resize 15")
		vim.api.nvim_win_set_buf(0, term.buf)
		term.win = vim.api.nvim_get_current_win()
		vim.cmd("startinsert")
	end
end

-- Keymaps
vim.keymap.set({ "n", "t" }, "<A-1>", function()
	M.toggle_terminal(1)
end, { desc = "Toggle Term 1" })
vim.keymap.set({ "n", "t" }, "<A-2>", function()
	M.toggle_terminal(2)
end, { desc = "Toggle Term 2" })
vim.keymap.set({ "n", "t" }, "<A-3>", function()
	M.toggle_terminal(3)
end, { desc = "Toggle Term 3" })

return M
