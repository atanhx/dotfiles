#!/bin/bash

# Copies dotfiles from $HOME/dotfiles to $HOME/.config
function copy_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles"
    local config_dir="$HOME/.config"

    # Copy hypr files
    if [[ -d "$dotfiles_dir/hypr" ]]; then
        cp -r "$dotfiles_dir/hypr" "$config_dir/" \
            || { echo "Error: could not copy hypr"; exit 1; }
    else
        echo "Warning: could not find hypr directory"
    fi

    # Copy alacritty files
    if [[ -d "$dotfiles_dir/alacritty" ]]; then
        cp -r "$dotfiles_dir/alacritty" "$config_dir/" \
            || { echo "Error: could not copy alacritty"; exit 1; }
    else
        echo "Warning: could not find alacritty directory"
    fi

    # Copy dunst files
    if [[ -d "$dotfiles_dir/dunst" ]]; then
        cp -r "$dotfiles_dir/dunst" "$config_dir/" \
            || { echo "Error: could not copy dunst"; exit 1; }
    else
        echo "Warning: could not find dunst directory"
    fi

    # Copy fontconfig files
    if [[ -d "$dotfiles_dir/fontconfig" ]]; then
        cp -r "$dotfiles_dir/fontconfig" "$config_dir/" \
            || { echo "Error: could not copy fontconfig"; exit 1; }
    else
        echo "Warning: could not find fontconfig directory"
    fi

    # Copy waybar files
    if [[ -d "$dotfiles_dir/waybar" ]]; then
        cp -r "$dotfiles_dir/waybar" "$config_dir/" \
            || { echo "Error: could not copy waybar"; exit 1; }
    else
        echo "Warning: could not find waybar directory"
    fi

    # Copy wlogout files
    if [[ -d "$dotfiles_dir/wlogout" ]]; then
        cp -r "$dotfiles_dir/wlogout" "$config_dir/" \
            || { echo "Error: could not copy wlogout"; exit 1; }
    else
        echo "Warning: could not find wlogout directory"
    fi

    # Copy wofi files
    if [[ -d "$dotfiles_dir/wofi" ]]; then
        cp -r "$dotfiles_dir/wofi" "$config_dir/" \
            || { echo "Error: could not copy wofi"; exit 1; }
    else
        echo "Warning: could not find wofi directory"
    fi
}

# Execute the script
copy_dotfiles