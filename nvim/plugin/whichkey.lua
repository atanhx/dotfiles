local wk = require("which-key")

wk.setup({})

wk.add({
  { "<leader>b", group = "Buffer" },
  { "<leader>c", group = "Code" },
  { "<leader>d", group = "Debug" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>h", group = "Harpoon" },
  { "<leader>l", group = "LSP" },
  { "<leader>q", group = "Quickfix / Quit" },
  { "<leader>s", group = "Search" },
  { "<leader>t", group = "Tab" },
  { "<leader>T", group = "Terminal" },
  { "<leader>u", group = "Toggle" },
  { "<leader>w", group = "Window" },
  { "<leader>x", group = "Execute" },
  { "<leader>y", group = "Yazi" },
  { "<leader>z", group = "Zen" },
  { "<leader>.", group = "Scratch" },
})
