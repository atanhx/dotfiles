local harpoon = require("harpoon")
harpoon:setup()

-- Workaround harpoon2 bug: function references leak into HarpoonConfig on save
local orig_save = harpoon.save
harpoon.save = function()
  pcall(orig_save)
end
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

vim.keymap.set("n", "<leader>hh", function()
  toggle_telescope(harpoon:list())
end, { desc = "Harpoon: list marks" })

vim.keymap.set("n", "<leader>ha", function()
  harpoon:list():add()
end, { desc = "Harpoon: add current file" })

vim.keymap.set("n", "<leader>h1", function()
  harpoon:list():select(1)
end, { desc = "Harpoon: go to mark 1" })

vim.keymap.set("n", "<leader>h2", function()
  harpoon:list():select(2)
end, { desc = "Harpoon: go to mark 2" })

vim.keymap.set("n", "<leader>h3", function()
  harpoon:list():select(3)
end, { desc = "Harpoon: go to mark 3" })

vim.keymap.set("n", "<leader>h4", function()
  harpoon:list():select(4)
end, { desc = "Harpoon: go to mark 4" })

vim.keymap.set("n", "<C-S-P>", function()
  harpoon:list():prev()
end, { desc = "Go to previous harpoon mark" })

vim.keymap.set("n", "<C-S-N>", function()
  harpoon:list():next()
end, { desc = "Go to next harpoon mark" })
