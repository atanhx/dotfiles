local function open_word_picker(word)
  if word == "" then return end

  local buflines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local matches = {}
  for i, line in ipairs(buflines) do
    local s = 1
    while true do
      local col = string.find(string.lower(line), vim.pesc(string.lower(word)), s)
      if not col then break end
      table.insert(matches, { lnum = i, col = col - 1 })
      s = col + #word
    end
  end
  if #matches == 0 then vim.notify("No matches for: " .. word); return end

  vim.fn.setreg("/", "\\V" .. vim.fn.escape(word, "\\/"))

  local target_buf = vim.api.nvim_get_current_buf()
  local target_ft = vim.bo[target_buf].filetype
  local selected = {}

  local buf = vim.api.nvim_create_buf(false, true)
  if target_ft and target_ft ~= "" then
    vim.bo[buf].filetype = target_ft
  end

  local lines = {}
  for i = 1, #matches do
    table.insert(lines, "  " .. matches[i].lnum .. "  " .. buflines[matches[i].lnum])
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = math.min(math.floor(vim.o.columns * 0.85), 120)
  local height = math.min(#matches + 2, 24)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = 1,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "single",
    title = " " .. word .. " (Space=select, Enter=edit, q=cancel) ",
    title_pos = "center",
  })
  vim.wo[win].cursorline = true

  local km = { buffer = buf, nowait = true }
  vim.keymap.set("n", "q", "<cmd>close!<CR>", km)
  vim.keymap.set("n", "<Esc>", "<cmd>close!<CR>", km)
  vim.keymap.set("n", "<Space>", function()
    local idx = vim.api.nvim_win_get_cursor(0)[1]
    selected[idx] = not selected[idx]
    local line = vim.api.nvim_buf_get_lines(buf, idx - 1, idx, false)[1]
    local mark = selected[idx] and ">" or " "
    vim.api.nvim_buf_set_lines(buf, idx - 1, idx, false, { mark .. line:sub(2) })
  end, km)
  vim.keymap.set("n", "<CR>", function()
    local new_word = vim.fn.input("Replace '" .. word .. "' with: ")
    if new_word == "" then vim.api.nvim_win_close(win, true); return end
    local count = 0
    for i, m in ipairs(matches) do
      if selected[i] then
        local ok = pcall(vim.api.nvim_buf_set_text, target_buf, m.lnum - 1, m.col, m.lnum - 1, m.col + #word, { new_word })
        if ok then count = count + 1 end
      end
    end
    vim.api.nvim_win_close(win, true)
    vim.cmd("nohlsearch")
    vim.notify(string.format("Replaced %d of %d occurrences", count, #matches))
  end, km)
end

vim.keymap.set("n", "<C-n>", function()
  open_word_picker(vim.fn.expand("<cword>"))
end, { desc = "Select word occurrences to edit" })

vim.keymap.set("x", "<C-n>", function()
  vim.cmd("silent! normal! " .. string.char(27))
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  local word
  if #lines == 1 then
    word = lines[1]:sub(start_pos[3], end_pos[3])
  elseif #lines > 1 then
    lines[1] = lines[1]:sub(start_pos[3])
    lines[#lines] = lines[#lines]:sub(1, end_pos[3])
    word = table.concat(lines, "\n")
  end
  if not word or #word == 0 then return end
  open_word_picker(word)
end, { desc = "Select occurrences of visual selection" })
