pcall(function()
  require("vim._core.ui2").enable()
end)

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    vim.keymap.set("n", "<leader>xb", "<cmd>%DB<CR>", {
      buffer = true,
      desc = "SQL: execute whole file",
    })
    vim.keymap.set("v", "<C-CR>", "<cmd>'<,'>DB<CR>", {
      buffer = true,
      desc = "SQL: execute selection",
    })
    local run_paragraph = "vip:DB<CR>"

    vim.keymap.set("n", "<C-CR>", run_paragraph, { buffer = true, desc = "SQL: execute paragraph" })
    vim.keymap.set("n", "<leader>xp", run_paragraph, { buffer = true, desc = "SQL: execute paragraph" })
  end,
})

local cursorGrp = augroup("CursorLine", { clear = true })
autocmd({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "set cursorline",
  group = cursorGrp,
})
autocmd({ "InsertEnter", "WinLeave" }, { pattern = "*", command = "set nocursorline", group = cursorGrp })
