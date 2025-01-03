#!/bin/bash

# Links dotfiles from $HOME/dotfiles to $HOME/.config
function link_dotfiles() {
    local dotfiles_dir="$HOME/dev/dotfiles"
    local config_dir="$HOME/.config"

    # Link hypr files
    if [[ -d "$dotfiles_dir/hypr" ]]; then
        ln -s "$dotfiles_dir/hypr" "$config_dir/hypr" \
            || { echo "Error: could not link hypr"; exit 1; }
    else
        echo "Warning: could not find hypr directory"
    fi

    # Link alacritty files
    if [[ -d "$dotfiles_dir/alacritty" ]]; then
        ln -s "$dotfiles_dir/alacritty" "$config_dir/alacritty" \
            || { echo "Error: could not link alacritty"; exit 1; }
    else
        echo "Warning: could not find alacritty directory"
    fi

    # Link dunst files
    if [[ -d "$dotfiles_dir/dunst" ]]; then
        ln -s "$dotfiles_dir/dunst" "$config_dir/dunst" \
            || { echo "Error: could not link dunst"; exit 1; }
    else
        echo "Warning: could not find dunst directory"
    fi

    # Link fontconfig files
    if [[ -d "$dotfiles_dir/fontconfig" ]]; then
        ln -s "$dotfiles_dir/fontconfig" "$config_dir/fontconfig" \
            || { echo "Error: could not link fontconfig"; exit 1; }
    else
        echo "Warning: could not find fontconfig directory"
    fi

    # Link waybar files
    if [[ -d "$dotfiles_dir/waybar" ]]; then
        ln -s "$dotfiles_dir/waybar" "$config_dir/waybar" \
            || { echo "Error: could not link waybar"; exit 1; }
    else
        echo "Warning: could not find waybar directory"
    fi

    # Link wlogout files
    if [[ -d "$dotfiles_dir/wlogout" ]]; then
        ln -s "$dotfiles_dir/wlogout" "$config_dir/wlogout" \
            || { echo "Error: could not link wlogout"; exit 1; }
    else
        echo "Warning: could not find wlogout directory"
    fi

    # Link wofi files
    if [[ -d "$dotfiles_dir/wofi" ]]; then
        ln -s "$dotfiles_dir/wofi" "$config_dir/wofi" \
            || { echo "Error: could not link wofi"; exit 1; }
    else
        echo "Warning: could not find wofi directory"
    fi
}

# Execute the script
link_dotfiles

# Install Zoxide
#
echo 'eval "$(zoxide init zsh)"' >> $HOME/.zshrc
