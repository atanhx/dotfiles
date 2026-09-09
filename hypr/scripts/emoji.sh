#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
source "${SCRIPT_DIR}/rofi_menu.sh"

DATA_FILE="${DOTFILES_DIR}/rofi/data/emojis.txt"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/rofi"
RECENT_FILE="${CACHE_DIR}/emoji_recent"

if [[ ! -f "${DATA_FILE}" ]]; then
    notify-send -t 2000 "Emoji Picker Error" "Emoji database not found at ${DATA_FILE}"
    exit 1
fi

collect_emojis() {
    if [[ -s "${RECENT_FILE}" ]]; then
        cat "${RECENT_FILE}"
        awk -F'\t' 'NR==FNR { seen[$1]=1; next } !seen[$1]' "${RECENT_FILE}" "${DATA_FILE}"
    else
        cat "${DATA_FILE}"
    fi
}

update_recent() {
    local selected_line="$1"
    mkdir -p "${CACHE_DIR}"
    {
        printf '%s\n' "${selected_line}"
        if [[ -f "${RECENT_FILE}" ]]; then
            cat "${RECENT_FILE}"
        fi
    } | awk -F'\t' '!seen[$1]++' | head -n 25 > "${RECENT_FILE}.tmp"
    mv "${RECENT_FILE}.tmp" "${RECENT_FILE}"
}

copy_and_type() {
    local emoji="$1"
    local name="${2:-Emoji}"
    local action="${3:-type}"

    # Always copy to primary wayland clipboard
    printf '%s' "${emoji}" | wl-copy

    if [[ "${action}" == "copy" ]] || ! command -v wtype >/dev/null 2>&1; then
        notify-send -t 1200 "Emoji Copied" "${emoji}  ${name}"
        return 0
    fi

    # Small delay for Rofi window to unmap and target window to regain focus
    sleep 0.08
    if ! wtype "${emoji}" 2>/dev/null; then
        notify-send -t 1200 "Emoji Copied" "${emoji}  ${name}"
    fi
}

copy_only_flag=false
if [[ "${1:-}" == "--copy-only" ]] || [[ "${1:-}" == "-c" ]]; then
    copy_only_flag=true
fi

# Run rofi with custom keybinding:
# Enter -> exit code 0 (Copy & Type)
# Alt+Enter -> exit code 10 (Copy Only)
set +e
selected_line=$(collect_emojis | rofi_run emoji -dmenu -p "󰞅  Emoji" -i -no-custom -kb-custom-1 "Alt+Return")
rofi_exit_code=$?
set -e

if [[ -z "${selected_line}" ]] || [[ "${rofi_exit_code}" -eq 1 ]]; then
    exit 0
fi

emoji=$(printf '%s' "${selected_line}" | awk -F'\t' '{print $1}')
name=$(printf '%s' "${selected_line}" | awk -F'\t' '{print $2}')

if [[ -z "${emoji}" ]]; then
    exit 0
fi

# Update recent emoji history
update_recent "${selected_line}"

# Determine action
if [[ "${copy_only_flag}" == true ]] || [[ "${rofi_exit_code}" -eq 10 ]]; then
    copy_and_type "${emoji}" "${name}" "copy"
else
    copy_and_type "${emoji}" "${name}" "type"
fi
