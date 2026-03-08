#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/rofi_menu.sh"

terminal_cmd="${TERMINAL:-alacritty}"

collect_history() {
    {
        if [[ -f "$HOME/.zsh_history" ]]; then
            tac "$HOME/.zsh_history" | sed 's/^: [0-9]\+:[0-9]\+;//'
        fi

        if [[ -f "$HOME/.bash_history" ]]; then
            tac "$HOME/.bash_history"
        fi
    } | awk 'NF && !seen[$0]++'
}

history_entries=$(collect_history)

if [[ -z "$history_entries" ]]; then
    notify-send -t 1200 "Shell History" "No bash/zsh history found"
    exit 0
fi

selection_index=$(printf '%s\n' "$history_entries" | rofi_run shell-history -dmenu -p "Shell History" -i -no-custom -l 12 -format i)

if [[ -z "$selection_index" ]]; then
    exit 0
fi

selection=$(printf '%s\n' "$history_entries" | sed -n "$((selection_index + 1))p")

if [[ -z "$selection" ]]; then
    exit 0
fi

action=$(printf 'Run\nCopy\n' | rofi_run shell-history-action -dmenu -p "History Action" -i -no-custom -l 2)

case "$action" in
    Run)
        exec "$terminal_cmd" -e zsh -ic "$selection; exec zsh"
        ;;
    Copy)
        printf '%s' "$selection" | wl-copy
        notify-send -t 1200 "Shell History" "Command copied"
        ;;
    *)
        exit 0
        ;;
esac
