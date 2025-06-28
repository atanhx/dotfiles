vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"

vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.showmode = false
vim.opt.smartindent = true

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.termguicolors = true

-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.scrolloff = 999
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80,190"

vim.opt.splitright = true
vim.opt.splitbelow = true

-- vim.cmd.colorscheme("retrobox")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
