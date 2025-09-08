#!/bin/bash

set -e

DOTFILES_DIR="${HOME}/dev/dotfiles"
CONFIG_DIR="${HOME}/.config"

CONFIG_TARGETS=(
    "hypr"
    "alacritty"
    "kitty"
    "dunst"
    "fontconfig"
    "waybar"
    "wlogout"
    "wofi"
    "nvim"
    "zed"
    "swaylock"
)

HOME_TARGETS=(
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
    
    setup_zoxide

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

setup_zoxide() {
    local zshrc_file="${HOME}/.zshrc"
    local zoxide_init_str='eval "$(zoxide init zsh)"'

    if ! grep -qF -- "${zoxide_init_str}" "${zshrc_file}"; then
        echo "Configuring zoxide in ${zshrc_file}..."
        echo -e "\nInitialize Zoxide\n${zoxide_init_str}" >> "${zshrc_file}"
    else
        echo "[DONE]: Zoxide already configured in ${zshrc_file}."
    fi
}

main
