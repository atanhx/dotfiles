#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/rofi_menu.sh"

options='lock:  Lock
logout:󰍃  Logout
suspend:󰒲  Suspend
reboot:󰜉  Reboot
shutdown:  Shutdown'

choice_text=$(printf '%s\n' "$options" | cut -d':' -f2 | rofi_run power -dmenu -p "Power" -i -no-custom -l 5)

if [[ -z "${choice_text}" ]]; then
    exit 0
fi

choice_key=$(printf '%s\n' "$options" | awk -F: -v selected="$choice_text" '$2 == selected { print $1 }')

case "$choice_key" in
    lock)
        exec hyprlock
        ;;
    logout)
        exec hyprctl dispatch exit
        ;;
    suspend)
        hyprlock &
        sleep 0.2
        exec systemctl suspend
        ;;
    reboot)
        exec systemctl reboot
        ;;
    shutdown)
        exec systemctl poweroff
        ;;
esac
