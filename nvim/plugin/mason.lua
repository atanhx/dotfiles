vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = true,
})

require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = {
    "clang-format",
    "stylua",
    "ruff",
    "prettier",
    "codelldb",
    "postgres-language-server",
    "sql-formatter",
    "ty",
    "ruff",
    "typescript-language-server",
    "tailwindcss-language-server",
    "lua-language-server",
    "clangd",
    "rust-analyzer",
  },
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end

vim.lsp.config["ts_ls"] = {
  capabilities = lsp_capabilities,
  on_attach = on_attach,
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", "tsconfig.json", ".git" },
}

vim.lsp.config["tailwindcss"] = {
  capabilities = lsp_capabilities,
  on_attach = on_attach,
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", ".git" },
}

vim.lsp.config["rust_analyzer"] = {
  capabilities = lsp_capabilities,
  on_attach = on_attach,
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
}

vim.lsp.config["lua_ls"] = {
  capabilities = lsp_capabilities,
  on_attach = on_attach,
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
    },
  },
}

vim.lsp.config["clangd"] = {
  capabilities = vim.tbl_deep_extend("force", lsp_capabilities, {
    offsetEncoding = { "utf-16" },
  }),
  on_attach = on_attach,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { ".clangd", "compile_commands.json", ".git" },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}

vim.lsp.config["ty"] = {
  capabilities = lsp_capabilities,
  on_attach = on_attach,
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
  settings = {
    ty = {
      diagnosticMode = "openFilesOnly",
      showSyntaxErrors = false,
      inlayHints = {
        variableTypes = false,
        callArgumentNames = false,
        returnTypes = false,
      },
      completions = { autoImport = true },
      disableLanguageServices = false,
    },
  },
}

vim.lsp.config["ruff"] = {
  capabilities = lsp_capabilities,
  on_attach = on_attach,
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
  init_options = {
    settings = {
      organizeImports = true,
      showSyntaxErrors = true,
      lint = { ignore = { "E501", "F401" } },
      logLevel = "debug",
    },
  },
}

vim.lsp.enable({ "ts_ls", "tailwindcss", "rust_analyzer", "lua_ls", "clangd", "ty", "ruff" })
