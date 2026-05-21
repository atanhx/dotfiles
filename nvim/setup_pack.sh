#!/usr/bin/env bash
set -euo pipefail

PACK_DIR="$HOME/dev/dotfiles/nvim/pack/myplugins/start"
mkdir -p "$PACK_DIR"

declare -A REPOS=(
  ["kanagawa.nvim"]="rebelot/kanagawa.nvim"
  ["nvim-cmp"]="hrsh7th/nvim-cmp"
  ["cmp-nvim-lsp"]="hrsh7th/cmp-nvim-lsp"
  ["cmp-path"]="hrsh7th/cmp-path"
  ["cmp_luasnip"]="saadparwaiz1/cmp_luasnip"
  ["LuaSnip"]="L3MON4D3/LuaSnip"
  ["conform.nvim"]="stevearc/conform.nvim"
  ["gitsigns.nvim"]="lewis6991/gitsigns.nvim"
  ["harpoon"]="ThePrimeagen/harpoon"
  ["lualine.nvim"]="nvim-lualine/lualine.nvim"
  ["mason.nvim"]="williamboman/mason.nvim"
  ["mason-tool-installer.nvim"]="WhoIsSethDaniel/mason-tool-installer.nvim"
  ["mason-nvim-dap.nvim"]="jay-babu/mason-nvim-dap.nvim"
  ["nvim-colorizer.lua"]="catgoose/nvim-colorizer.lua"
  ["nvim-tree.lua"]="nvim-tree/nvim-tree.lua"
  ["nvim-web-devicons"]="nvim-tree/nvim-web-devicons"
  ["nvim-dap"]="mfussenegger/nvim-dap"
  ["nvim-dap-ui"]="rcarriga/nvim-dap-ui"
  ["nvim-nio"]="nvim-neotest/nvim-nio"
  ["nvim-treesitter"]="nvim-treesitter/nvim-treesitter"
  ["nvim-treesitter-context"]="nvim-treesitter/nvim-treesitter-context"
  ["plenary.nvim"]="nvim-lua/plenary.nvim"
  ["snacks.nvim"]="folke/snacks.nvim"
  ["tabout.nvim"]="abecodes/tabout.nvim"
  ["telescope.nvim"]="nvim-telescope/telescope.nvim"
  ["todo-comments.nvim"]="folke/todo-comments.nvim"
  ["trouble.nvim"]="folke/trouble.nvim"
  ["undotree"]="mbbill/undotree"
  ["uv.nvim"]="benomahony/uv.nvim"
  ["vim-dadbod"]="tpope/vim-dadbod"
  ["vim-dadbod-completion"]="kristijanhusak/vim-dadbod-completion"
  ["vim-dadbod-ui"]="kristijanhusak/vim-dadbod-ui"
  ["which-key.nvim"]="folke/which-key.nvim"
  ["yazi.nvim"]="mikavilpas/yazi.nvim"
)

for dir in "${!REPOS[@]}"; do
  repo="${REPOS[$dir]}"
  target="$PACK_DIR/$dir"
  if [ -d "$target" ]; then
    echo "Already exists: $dir"
  else
    echo "Cloning $repo -> $dir"
    git clone --depth 1 "https://github.com/$repo.git" "$target"
  fi
done

echo ""
echo "All plugins cloned to $PACK_DIR"
echo "Restart Neovim for changes to take effect."
