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
    local stream
    if [[ -s "${RECENT_FILE}" ]]; then
        stream=$(
            cat "${RECENT_FILE}"
            awk -F'\t' 'NR==FNR { seen[$1]=1; next } !seen[$1]' "${RECENT_FILE}" "${DATA_FILE}"
        )
    else
        stream=$(cat "${DATA_FILE}")
    fi

    printf '%s\n' "${stream}" | awk -F'\t' 'NF >= 2 {
        printf "%s  %s\t%s\t%s\t%s\n", $1, $2, $1, $2, $3
    }'
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
    local count="${4:-1}"

    local payload=""
    if [[ "${count}" -gt 1 ]]; then
        for ((i = 0; i < count; i++)); do
            payload+="${emoji}"
        done
    else
        payload="${emoji}"
    fi

    # Always copy to primary wayland clipboard
    printf '%s' "${payload}" | wl-copy

    if [[ "${action}" == "copy" ]] || ! command -v wtype >/dev/null 2>&1; then
        local msg="${payload}  ${name}"
        [[ "${count}" -gt 1 ]] && msg="${payload} (${count}x)"
        notify-send -t 1200 "Emoji Copied" "${msg}"
        return 0
    fi

    # Small delay for Rofi window to unmap and target window to regain focus
    sleep 0.08
    if ! wtype "${payload}" 2>/dev/null; then
        notify-send -t 1200 "Emoji Copied" "${payload}"
    fi
}

copy_only_flag=false
if [[ "${1:-}" == "--copy-only" ]] || [[ "${1:-}" == "-c" ]]; then
    copy_only_flag=true
fi

# Run rofi with custom keybindings:
# Enter       -> exit code 0  (Copy & Type 1x)
# Alt+Enter   -> exit code 10 (Copy Only 1x)
# Shift+Enter -> exit code 11 (Spam / Burst Type 5x)
set +e
selected_line=$(collect_emojis | rofi_run emoji -dmenu -matching normal -i -no-sort -display-columns 1 -display-column-separator $'\t' -p "󰞅  Emoji" -no-custom -kb-accept-alt "" -kb-accept-custom "" -kb-custom-1 "Alt+Return" -kb-custom-2 "Shift+Return")
rofi_exit_code=$?
set -e

if [[ -z "${selected_line}" ]] || [[ "${rofi_exit_code}" -eq 1 ]]; then
    exit 0
fi

emoji=$(printf '%s' "${selected_line}" | awk -F'\t' '{print $2}')
name=$(printf '%s' "${selected_line}" | awk -F'\t' '{print $3}')
raw_entry=$(printf '%s' "${selected_line}" | awk -F'\t' '{printf "%s\t%s\t%s", $2, $3, $4}')

if [[ -z "${emoji}" ]]; then
    exit 0
fi

# Update recent emoji history
update_recent "${raw_entry}"

# Determine action
if [[ "${copy_only_flag}" == true ]] || [[ "${rofi_exit_code}" -eq 10 ]]; then
    copy_and_type "${emoji}" "${name}" "copy" 1
elif [[ "${rofi_exit_code}" -eq 11 ]]; then
    # Spam mode: burst type 5x emojis at once (configurable via EMOJI_SPAM_COUNT)
    spam_count="${EMOJI_SPAM_COUNT:-5}"
    copy_and_type "${emoji}" "${name}" "type" "${spam_count}"
else
    copy_and_type "${emoji}" "${name}" "type" 1
fi
