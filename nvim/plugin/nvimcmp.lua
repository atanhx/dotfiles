local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  performance = {
    max_view_entries = 7,
  },
  completion = { completeopt = "menu,menuone,noinsert" },
  view = {
    docs = {
      auto_open = false,
    },
  },
  window = {
    completion = {
      border = "single",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
    documentation = {
      border = "single",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    },
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.abbr = vim_item.abbr:match("[%w_%.]+") or vim_item.abbr
      if vim_item.menu and #vim_item.menu > 40 then
        vim_item.menu = vim_item.menu:sub(1, 40) .. "…"
      end
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-b>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-f>"] = cmp.mapping.scroll_docs(-4),
    ["<C-g>"] = cmp.mapping.scroll_docs(4),
    ["<C-k>"] = cmp.mapping.open_docs(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete({}),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  },
})

cmp.setup.filetype({ "sql" }, {
  sources = {
    { name = "vim-dadbod-completion", group_index = 1 },
    { name = "buffer", group_index = 2 },
  },
})
