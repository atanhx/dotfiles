#!/usr/bin/env bash
set -euo pipefail

PACK_DIR="$HOME/dev/dotfiles/nvim/pack/myplugins/start"
MODE="sync" # sync | update | clone

declare -A REPOS=(
  ["kanagawa.nvim"]="rebelot/kanagawa.nvim"
  ["gruvbox-material"]="f4z3r/gruvbox-material.nvim"
  ["bufferline.nvim"]="akinsho/bufferline.nvim"
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

usage() {
    echo "Usage: $0 [--update|--clone]"
    echo "  default  : clone missing plugins and update existing ones"
    echo "  --update : only update existing plugins"
    echo "  --clone  : only clone missing plugins"
}

while [ $# -gt 0 ]; do
    case "$1" in
        --update) MODE="update" ;;
        --clone) MODE="clone" ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown argument: $1"; usage; exit 1 ;;
    esac
    shift
done

mkdir -p "$PACK_DIR"

for dir in "${!REPOS[@]}"; do
    repo="${REPOS[$dir]}"
    target="$PACK_DIR/$dir"
    if [ -d "$target" ]; then
        if [ "$MODE" != "clone" ]; then
            echo "Updating $dir..."
            git -C "$target" pull --ff-only
        fi
    elif [ "$MODE" != "update" ]; then
        echo "Cloning $repo -> $dir"
        git clone --depth 1 "https://github.com/$repo.git" "$target"
    fi
done

echo ""
echo "Done. Restart Neovim for changes to take effect."
