#!/bin/bash

set -euo pipefail

DOTFILES_DIR="${HOME}/dev/dotfiles"
CONFIG_DIR="${HOME}/.config"
OH_MY_ZSH_DIR="${HOME}/.oh-my-zsh"

CONFIG_TARGETS=(
    "hypr"
    "alacritty"
    "kitty"
    "dunst"
    "fontconfig"
    "waybar"
    "rofi"
    "nvim"
    "wofi"
    "zed"
)

HOME_TARGETS=(
    ".tmux.conf"
    ".zshrc"
)

main() {
    echo "[START]: Starting dotfiles setup..."
    mkdir -p "${CONFIG_DIR}"

    for target in "${CONFIG_TARGETS[@]}"; do
        link_item "${DOTFILES_DIR}/${target}" "${CONFIG_DIR}/${target}"
    done

    for target in "${HOME_TARGETS[@]}"; do
        link_item "${DOTFILES_DIR}/${target}" "${HOME}/${target}"
    done

    ensure_oh_my_zsh
    setup_zoxide
    fix_xdg_menu

    echo "[DONE]: Dotfiles setup complete!"
}

link_item() {
    local src="$1"
    local dest="$2"

    if [ ! -e "${src}" ]; then
        echo "[WARNING]: Source '${src}' not found. Skipping."
        return
    fi

    if [ -L "${dest}" ]; then
        echo "Removing existing symlink at '${dest}'."
        rm "${dest}"
    elif [ -e "${dest}" ]; then
        echo "Backing up existing file/directory at '${dest}' to '${dest}.bak'."
        mv "${dest}" "${dest}.bak"
    fi

    echo "Linking '${src}' to '${dest}'."
    ln -s "${src}" "${dest}"
}

ensure_oh_my_zsh() {
    if ! command -v zsh >/dev/null 2>&1; then
        echo "[WARNING]: zsh is not installed. Install it from pkgs.arch.txt first, then rerun this script."
        return
    fi

    if [ -d "${OH_MY_ZSH_DIR}" ]; then
        echo "[DONE]: Oh My Zsh already installed at '${OH_MY_ZSH_DIR}'."
        return
    fi

    if ! command -v curl >/dev/null 2>&1; then
        echo "[WARNING]: curl is required to install Oh My Zsh. Skipping."
        return
    fi

    echo "Installing Oh My Zsh into '${OH_MY_ZSH_DIR}'..."
    RUNZSH=no CHSH=yes KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

setup_zoxide() {
    local zshrc_file="${HOME}/.zshrc"
    local zoxide_init_str='eval "$(zoxide init zsh)"'

    if [ ! -f "${zshrc_file}" ]; then
        echo "[WARNING]: '${zshrc_file}' does not exist yet. Skipping zoxide setup."
        return
    fi

    if ! grep -qF -- "${zoxide_init_str}" "${zshrc_file}"; then
        echo "Configuring zoxide in ${zshrc_file}..."
        printf '\n# Initialize zoxide\n%s\n' "${zoxide_init_str}" >> "${zshrc_file}"
    else
        echo "[DONE]: Zoxide already configured in ${zshrc_file}."
    fi
}

detect_distro() {
    if [ -r /etc/os-release ]; then
        . /etc/os-release
        echo "${ID:-unknown}"
    else
        echo "unknown"
    fi
}

fix_xdg_menu() {
    local distro
    distro="$(detect_distro)"

    case "$distro" in
        arch|endeavouros|manjaro|garuda|cachyos) ;;
        *)
            echo "[WARNING]: Unsupported distro '$distro'; skipping XDG menu setup." >&2
            return 0
            ;;
    esac

    sudo pacman -S --needed --noconfirm archlinux-xdg-menu

    local menu_source=""
    if [[ -f /etc/xdg/menus/arch-applications.menu ]]; then
        menu_source="/etc/xdg/menus/arch-applications.menu"
    elif [[ -f /etc/xdg/menus/plasma-applications.menu ]]; then
        menu_source="/etc/xdg/menus/plasma-applications.menu"
    else
        echo "Error: Neither arch-applications.menu nor plasma-applications.menu found." >&2
        return 1
    fi

    sudo ln -sf "$menu_source" /etc/xdg/menus/applications.menu

    if command -v update-desktop-database >/dev/null 2>&1; then
        sudo update-desktop-database
    fi
    if command -v kbuildsycoca6 >/dev/null 2>&1; then
        kbuildsycoca6 --noincremental
    fi

    echo "[DONE]: XDG Menu Prefix updated"
}

main
