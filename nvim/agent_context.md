# Neovim Configuration Reference

## Overview

- **Neovim version**: 0.12.2
- **Plugin system**: vim-pack (built-in `pack/myplugins/start/`)
- **Config location**: `~/dev/dotfiles/nvim/`
- **Plugin manager**: None (plugins installed via `setup_pack.sh` as git clones)
- **Boot time**: All plugins load at startup (no lazy loading)

## Directory Structure

```
nvim/
  init.lua                     # Entry point: vim.loader.enable, require config.remap + config.set
  lua/config/
    remap.lua                  # Global keymaps and leader keys
    set.lua                    # General options/settings
  plugin/                      # Auto-sourced by Neovim at startup
    colorscheme.lua            # kanagawa.nvim
    core.lua                   # Autocmds, ui2
    mason.lua                  # Mason + LSP configs
    nvimcmp.lua                # nvim-cmp (autocompletion)
    snacker.lua                # snacks.nvim (picker, notifier, dashboard, etc.)
    debug.lua                  # nvim-dap + nvim-dap-ui
    format.lua                 # conform.nvim
    gitsigns.lua               # gitsigns.nvim
    harpoon.lua                # harpoon2
    lualine.lua                # lualine.nvim
    nvim-tree.lua              # nvim-tree.lua
    nvim-colorizer.lua         # nvim-colorizer.lua
    sql.lua                    # vim-dadbod-ui
    tabout.lua                 # tabout.nvim
    todo.lua                   # todo-comments.nvim
    treesitter.lua             # nvim-treesitter-context
    trouble.lua                # trouble.nvim
    uv.lua                     # uv.nvim (Python venv management)
    whichkey.lua               # which-key.nvim
    yazi.lua                   # yazi.nvim
  pack/myplugins/start/        # All plugins cloned here (gitignored)
  setup_pack.sh                # Script to clone all plugins
```

## Plugin Details

### init.lua
- `vim.loader.enable()` - enables Neovim's built-in Lua loader optimization
- Loads `lua/config/remap.lua` and `lua/config/set.lua`

### remap.lua (Global Keymaps)

Leader: `<Space>`, LocalLeader: `\`

**Search/Diagnostics**
- `<Esc>` - Clear search highlights (`:nohlsearch`)
- `<leader>q` - Open quickfix list with diagnostics
- `gl` - Open diagnostic float
- `]q` / `[q` - Next/previous quickfix item
- `<leader>j` / `<leader>k` - Next/previous location list item

**Navigation**
- `<C-d>` / `<C-u>` - Scroll down/up, keep cursor centered
- `n` / `N` - Next/prev search result, keep cursor centered
- `J` - Join lines, keep cursor position
- `<M-f>` - Toggle NvimTree file find
- `<C-t>` - New tab
- `<leader>tp` / `<leader>tn` / `<leader>tx` - Tab prev/next/close
- `<leader>sr` - Replace word under cursor across file
- `<leader>sR` - Replace visual selection across file

**Window Management**
- `vs` - Vertical split
- `<C-h/j/k/l>` - Navigate splits
- `<C-Up/Down/Left/Right>` - Resize splits

**Clipboard**
- `y` (n/v) - Yank to system clipboard
- `<leader>Y` - Yank line to system clipboard
- `p` (visual) - Paste without overwriting clipboard
- `<leader>dd` - Delete without yanking

**Editing**
- `Q` - Disabled (nop)
- `<C-s>` - Select all
- `<leader>ca` - LSP code action
- `<leader>ut` - Toggle undotree
- `K` (in insert mode) - LSP hover
- `<C-h>` (in insert mode) - LSP signature help

**Visual Mode**
- `J` / `K` - Move line down/up
- `<` / `>` - Indent left/right (stay selected)

**Other**
- `<leader>qa` - Save all and quit
- `i <C-c>` / `jk` - Exit insert mode
- `i <C-H>` - Delete word backwards
- `<C-a>` - Select all

### set.lua (Options)

```
guicursor      = "n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20"
number         = true
relativenumber = true
mouse          = "a"
clipboard      = "unnamedplus"
tabstop        = 4
softtabstop    = 4
shiftwidth     = 4
expandtab      = true
showmode       = false
smartindent    = true
laststatus     = 3
wrap           = true
swapfile       = false
backup         = false
undodir        = ~/.vim/undodir
undofile       = true
hlsearch       = false
incsearch      = true
inccommand     = "split"
termguicolors  = true
scrolloff      = 999
signcolumn     = "yes"
updatetime     = 50
colorcolumn    = "999"
splitright     = true
splitbelow     = true
isfname        += "@-@"

netrw disabled (browse_split=0, banner=0, winsize=25)
Normal/NormalFloat hl: bg = "none" (transparent background)
```

### core.lua (Autocmds)
- `ui2` enabled via `pcall(require("vim._core.ui2").enable())` (experimental cmdline UI)
- `TextYankPost` - highlight yanked text (IncSearch, 40ms)
- `FileType sql` - buffer-local keymaps for DB execution
- `CursorLine` augroup - cursorline on InsertLeave/WinEnter, off on InsertEnter/WinLeave

### colorscheme.lua (kanagawa)
- Theme: wave (dark), lotus (light)
- Transparent background, dim inactive windows, terminal colors
- Italic comments/keywords, bold statements
- No compile caching

### mason.lua (LSP Infrastructure)

**mason.nvim** + **mason-tool-installer.nvim** auto-install these tools:
- `clang-format`, `stylua`, `ruff`, `prettier`, `codelldb`
- `postgres-language-server`, `sql-formatter`
- `typescript-language-server`, `tailwindcss-language-server`
- `lua-language-server`, `clangd`, `rust-analyzer`
- `ty`

**vim.lsp.config** (Neovim 0.12 native LSP config) - 7 LSP clients:

| Config name | Server command | Filetypes | Root markers |
|---|---|---|---|
| `ts_ls` | `typescript-language-server --stdio` | js, jsx, ts, tsx | package.json, tsconfig.json, .git |
| `tailwindcss` | `tailwindcss-language-server --stdio` | html, css, js, jsx, ts, tsx | tailwind.config.*, postcss.config.*, .git |
| `rust_analyzer` | `rust-analyzer` | rust | Cargo.toml, .git |
| `lua_ls` | `lua-language-server` | lua | .luarc.json, .git |
| `clangd` | `clangd --background-index --clang-tidy ...` | c, cpp, objc, objcpp | .clangd, compile_commands.json, .git |
| `ty` | `ty server` | python | pyproject.toml, setup.py, setup.cfg, .git |
| `ruff` | `ruff server` | python | pyproject.toml, setup.py, setup.cfg, .git |

Enabled via: `vim.lsp.enable({"ts_ls", "tailwindcss", "rust_analyzer", "lua_ls", "clangd", "ty", "ruff"})`

**Global LSP keymaps** (via on_attach):
- `K` - Hover
- `<C-h>` - Signature help
- `<leader>ca` - Code action (set in remap.lua)

**Diagnostics config**: virtual_text, signs, underline, severity_sort, update_in_insert, float

### nvimcmp.lua (Autocompletion)

**nvim-cmp** with **LuaSnip** for snippet expansion.

Sources (global): `nvim_lsp`, `luasnip`, `path`

Sources (sql): `vim-dadbod-completion` (group 1), `buffer` (group 2)

Popups use `single` border. Docs window does **not** auto-open.

Completion keymaps:
- `<C-n>` / `<C-b>` - Next/prev item
- `<C-f>` / `<C-g>` - Scroll docs up/down
- `<C-k>` - Open docs for selected item
- `<C-y>` / `<CR>` - Confirm selection
- `<C-Space>` - Force complete

**Formatting**: Labels show only the identifier name (e.g. `print`, not the full signature). Menu text (overload info) capped at 40 chars.

Performance: max_view_entries=7, completeopt=menu,menuone,noinsert

### snacker.lua (snacks.nvim)

**Enabled features**: dashboard, input (float), picker, notifier, quickfile, statuscolumn, inlay_hints toggle

**Global debug functions**:
- `_G.dd(...)` - Snacks.debug.inspect
- `_G.bt()` - Snacks.debug.backtrace
- `vim.print` - Overridden to use dd

**Toggle keymaps** (Snacks.toggle):
- `<leader>us` - Spell
- `<leader>uw` - Wrap
- `<leader>uL` - Relative number
- `<leader>ud` - Diagnostics
- `<leader>ul` - Line number
- `<leader>uc` - Conceal level
- `<leader>uT` - Treesitter
- `<leader>ub` - Dark/light background
- `<leader>uh` - Inlay hints
- `<leader>ug` - Indent
- `<leader>uD` - Dim

**Inlay hints**: auto-enabled on LspAttach if client supports `textDocument/inlayHint`

**Picker keymaps (Snacks.picker)**:

| Key | Action |
|---|---|
| `<leader><space>` | Smart find |
| `<leader>,` | Buffers |
| `<leader>/` | Grep |
| `<leader>:` | Command history |
| `<leader>n` | Notification history |
| `<leader>fb` | Buffers |
| `<leader>fc` | Config files |
| `<leader>ff` | Find files |
| `<leader>fg` | Git files |
| `<leader>fp` | Projects |
| `<leader>fr` | Recent |
| `<leader>gb` | Git branches |
| `<leader>gl` | Git log |
| `<leader>gL` | Git log line |
| `<leader>gs` | Git status |
| `<leader>gS` | Git stash |
| `<leader>gd` | Git diff (hunks) |
| `<leader>gf` | Git log file |
| `<leader>sb` | Buffer lines |
| `<leader>sB` | Grep open buffers |
| `<leader>sg` | Grep |
| `<leader>sw` (n/x) | Grep word/selection |
| `<leader>s"` | Registers |
| `<leader>s/` | Search history |
| `<leader>sa` | Autocmds |
| `<leader>sc` | Command history |
| `<leader>sC` | Commands |
| `<leader>sd` | Diagnostics |
| `<leader>sD` | Buffer diagnostics |
| `<leader>sh` | Help pages |
| `<leader>sH` | Highlights |
| `<leader>si` | Icons |
| `<leader>sj` | Jumps |
| `<leader>sk` | Keymaps |
| `<leader>sl` | Location list |
| `<leader>sm` | Marks |
| `<leader>sM` | Man pages |
| `<leader>sq` | Quickfix list |
| `<leader>sR` | Resume |
| `<leader>su` | Undo history |
| `<leader>uC` | Colorschemes |

**LSP picker keymaps**:
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - References
- `gI` - Go to implementation
- `gy` - Go to type definition
- `<leader>ss` - LSP symbols
- `<leader>sS` - LSP workspace symbols

**Other Snacks keymaps**:
- `<leader>z` - Toggle zen mode
- `<leader>Z` - Toggle zoom
- `<leader>.` - Toggle scratch buffer
- `<leader>S` - Select scratch buffer
- `<leader>bd` - Delete buffer
- `<leader>cR` - Rename file
- `<leader>gB` (n/v) - Git browse
- `<leader>gg` - Lazygit
- `<leader>un` - Dismiss all notifications
- `<c-/>` / `<c-_>` - Terminal
- `]]` / `[[` (n/t) - Next/prev word reference
- `<leader>N` - Neovim news

### debug.lua (nvim-dap)

**DAP UI**: auto opens on attach/launch, auto closes on terminate/exit

**Debugger**: codelldb for C/C++/Rust

**Keymaps**:
- `<F5>` - Continue
- `<F1>` - Step over
- `<F2>` - Step into
- `<F3>` - Step out
- `<F12>` - Toggle breakpoint
- `<leader>dr` - Restart
- `<leader>dq` - Terminate and close UI
- `<leader>B` - Conditional breakpoint

### format.lua (conform.nvim)

**Format on save**: enabled (500ms timeout, LSP fallback)

**Formatters by filetype**:
- lua: stylua
- python: ruff, ruff_format, ruff_organize_imports
- javascript: prettierd, prettier
- sql: sql_formatter (args: `-l postgresql`)

**Manual format**: `<leader>cf`

### gitsigns.lua

Custom sign characters for add/change/delete. Signs enabled for staged changes too.
Current line blame disabled by default. Max file length 40000 lines.

### harpoon.lua (harpoon2)

Uses telescope.nvim for the picker UI.

**Keymaps**:
- `<leader>hh` - Open harpoon window (telescope)
- `<leader>ha` - Add current file to list
- `<leader>h1`-`<leader>h4` - Go to mark 1-4
- `<C-S-P>` / `<C-S-N>` - Previous/next mark

**Workaround**: `harpoon.save()` wrapped in `pcall()` to prevent json_encode crash on VimLeave.

### lualine.lua

**Statusline**: mode | branch, diff, diagnostics | filename | terminal_status, encoding, filetype | location

Custom `terminal_status()` component shows active snacks terminal buffers.
Global statusline, no component/separator chars. Auto theme.

### nvim-tree.lua

Disables netrw. Case-sensitive sort. Shows dotfiles. Git integration enabled.
Width: 30.

### nvim-colorizer.lua

Highlights color codes. Supports: names, RGB/RGBA/RRGGBB/RRGGBBAA/AARRGGBB, css/rgb/hsl functions, sass.
Mode: background (colors displayed as background highlight).

### sql.lua (vim-dadbod-ui)

Sets `vim.g.db_ui_save_location` to `stdpath("config")/db_ui`.
On FileType sql: sets omnifunc for dadbod completion, auto-finds DBUI buffer.

**Keymaps** (buffer-local for sql files):
- `<leader>xb` - Execute entire SQL file
- `<C-CR>` (visual) - Execute selection
- `<C-CR>` / `<leader>xp` (normal) - Execute paragraph

### tabout.lua

Tab out of brackets/quotes. Uses `<Tab>` / `<S-Tab>`. Supports: `'`, `"`, `` ` ``, `()`, `[]`, `{}`.
Completion-aware. Ignores beginning of filled elements.

### todo.lua (todo-comments.nvim)

No signs in gutter. Highlights TODO/FIXME/HACK/etc. comments.

### treesitter.lua (nvim-treesitter-context)

Shows function/class context line at top of window. Cursor mode, outer scope trim, multiline threshold 20, line numbers shown.

### trouble.lua (trouble.nvim)

Diagnostics list. No icons.

**Keymaps**:
- `<leader>tt` - Toggle trouble
- `[t` / `]t` - Next/prev diagnostic (skip groups, jump)

### whichkey.lua

Group labels for category-prefix system: Buffer, Code, Debug, Find, Git, Harpoon, LSP, Quickfix/Quit, Search, Tab, Terminal, Toggle, Window, Execute, Yazi, Zen, Scratch.

### yazi.lua (yazi.nvim)

File manager integration. Does NOT auto-open for directories (`open_for_directories=false`).

**Keymaps**:
- `<leader>yy` (n/v) - Open yazi at current file
- `<leader>yc` - Open yazi in cwd
- `<c-up>` - Resume last yazi session

### uv.lua (uv.nvim)

Python venv/project management. Picker integration with snacks.nvim.
Wrapped in pcall (module name may vary).

## Installed Plugins (34 total)

All at `pack/myplugins/start/`:

kanagawa.nvim, nvim-cmp, cmp-nvim-lsp, cmp-path, cmp_luasnip, LuaSnip,
conform.nvim, gitsigns.nvim, harpoon, lualine.nvim, mason.nvim,
mason-tool-installer.nvim, mason-nvim-dap.nvim, nvim-colorizer.lua,
nvim-tree.lua, nvim-web-devicons, nvim-dap, nvim-dap-ui, nvim-nio,
nvim-treesitter, nvim-treesitter-context, plenary.nvim, snacks.nvim,
tabout.nvim, telescope.nvim, todo-comments.nvim, trouble.nvim, undotree,
uv.nvim, vim-dadbod, vim-dadbod-completion, vim-dadbod-ui, which-key.nvim,
yazi.nvim

## Bootstrap

Run `setup_pack.sh` to clone all plugins from scratch. Requires git.
`.gitignore` excludes `nvim/pack/` and `db_ui/`.
