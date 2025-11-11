#!/usr/bin/env bash

options="suspend: Suspend
logout: Logout
reboot: Reboot
shutdown: Shutdown"

choice=$(echo "$options" | cut -d':' -f2 | wofi --conf "$HOME/dev/dotfiles/wofi/custom/powermenu/config" --style "$HOME/dev/dotfiles/wofi/custom/powermenu/style.css" --show dmenu --normal-window)

key=$(echo "$options" | grep "$choice" | cut -d':' -f1)

case "$key" in
    suspend)
        /usr/bin/systemctl suspend
        ;;
    logout)
        /usr/bin/hyprctl dispatch exit
        ;;
    reboot)
        /usr/bin/systemctl reboot
        ;;
    shutdown)
        /usr/bin/systemctl poweroff
        ;;
esac
