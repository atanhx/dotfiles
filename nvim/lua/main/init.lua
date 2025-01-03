require('main.remap')
require('main.set')
require('main.lazy_init')

local augroup = vim.api.nvim_create_augroup
local Teal = augroup('Teal', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = Teal,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = Teal,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts, { desc = "Go to definition" })
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts, { desc = "Show LSP hover information" })
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts,
            { desc = "Find LSP workspace symbol" })
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts,
            { desc = "Show diagnostics for current line" })
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts,
            { desc = "Show LSP code actions" })
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts,
            { desc = "Show LSP references" })
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts, { desc = "LSP rename symbol" })
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts,
            { desc = "Show LSP signature help" })
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts, { desc = "Go to next diagnostic" })
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts, { desc = "Go to previous diagnostic" })
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
