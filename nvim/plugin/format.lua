require("conform").setup({
  notify_on_error = true,
  format_on_save = function(bufnr)
    local disable_filetypes = {}
    local lsp_format_opt
    if disable_filetypes[vim.bo[bufnr].filetype] then
      lsp_format_opt = "never"
    else
      lsp_format_opt = "fallback"
    end
    return {
      timeout_ms = 500,
      lsp_format = lsp_format_opt,
    }
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff", "ruff_format", "ruff_organize_imports" },
    javascript = { "prettierd", "prettier" },
    sql = { "sql_formatter" },
  },
  formatters = {
    sql_formatter = {
      prepend_args = { "-l", "postgresql" },
    },
  },
})

vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format current buffer" })
