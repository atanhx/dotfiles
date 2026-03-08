#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/rofi_menu.sh"

cliphist_thumbnail_dir() {
    printf '%s' "${XDG_CACHE_HOME:-$HOME/.cache}/cliphist/rofi-thumbnails"
}

cliphist_thumbnail_ext() {
    local format=${1:?missing image format}

    case "$format" in
        jpeg)
            printf '%s' 'jpg'
            ;;
        *)
            printf '%s' "$format"
            ;;
    esac
}

cliphist_ensure_thumbnail() {
    local clip_id=${1:?missing cliphist id}
    local image_format=${2:?missing image format}
    local thumbnail_dir thumbnail_path

    thumbnail_dir="$(cliphist_thumbnail_dir)"
    mkdir -p "$thumbnail_dir"

    thumbnail_path="${thumbnail_dir}/${clip_id}.$(cliphist_thumbnail_ext "$image_format")"

    if [[ ! -s "$thumbnail_path" ]]; then
        if ! printf '%s\t' "$clip_id" | cliphist decode > "$thumbnail_path" 2>/dev/null; then
            rm -f -- "$thumbnail_path"
            return 1
        fi
    fi

    printf '%s' "$thumbnail_path"
}

cliphist_cleanup_thumbnails() {
    local thumbnail_dir clip_id thumbnail_file

    thumbnail_dir="$(cliphist_thumbnail_dir)"

    [[ -d "$thumbnail_dir" ]] || return 0

    while IFS= read -r -d '' thumbnail_file; do
        clip_id=$(basename "${thumbnail_file%.*}")
        if ! grep -q "^${clip_id}"$'\t' <<< "$entries"; then
            rm -f -- "$thumbnail_file"
        fi
    done < <(find "$thumbnail_dir" -type f -print0)
}

cliphist_rofi_rows() {
    local entry clip_id image_format thumbnail_path

    while IFS= read -r entry; do
        if [[ "$entry" =~ ^([0-9]+)$'\t'\[\[\ binary\ data\ .*\ (jpe?g|png|bmp|gif|tiff|webp)\ [0-9]+x[0-9]+\ \]\]$ ]]; then
            clip_id=${BASH_REMATCH[1]}
            image_format=${BASH_REMATCH[2]}
            thumbnail_path=$(cliphist_ensure_thumbnail "$clip_id" "$image_format") || {
                printf '%s\n' "$entry"
                continue
            }

            printf '%s\0icon\x1f%s\n' "$entry" "$thumbnail_path"
            continue
        fi

        printf '%s\n' "$entry"
    done
}

actions='copy:  Copy entry
delete:󰆴  Delete entry
clear:󰩺  Clear history'

action_text=$(printf '%s\n' "$actions" | cut -d':' -f2 | rofi_run clipboard-action -dmenu -p "Clipboard Action" -i -no-custom -l 3)

if [[ -z "${action_text}" ]]; then
    exit 0
fi

action_key=$(printf '%s\n' "$actions" | awk -F: -v selected="$action_text" '$2 == selected { print $1 }')

if [[ "$action_key" == "clear" ]]; then
    confirm=$(printf 'No\nYes\n' | rofi_run clipboard-confirm -dmenu -p "Clear clipboard history?" -i -no-custom -l 2)
    if [[ "$confirm" == "Yes" ]]; then
        cliphist wipe
        notify-send -t 1200 "Clipboard" "History cleared"
    fi
    exit 0
fi

entries=$(cliphist list)

if [[ -z "${entries}" ]]; then
    notify-send -t 1200 "Clipboard" "History is empty"
    exit 0
fi

cliphist_cleanup_thumbnails

selection_index=$(printf '%s\n' "$entries" | cliphist_rofi_rows | rofi_run clipboard-history -dmenu -p "Clipboard" -i -no-custom -l 10 -format i -display-columns 2 -display-column-separator '\t')

if [[ -z "${selection_index}" ]]; then
    exit 0
fi

selection=$(printf '%s\n' "$entries" | sed -n "$((selection_index + 1))p")

if [[ -z "${selection}" ]]; then
    exit 0
fi

case "$action_key" in
    copy)
        printf '%s' "$selection" | cliphist decode | wl-copy
        notify-send -t 1200 "Clipboard" "Selection copied"
        ;;
    delete)
        printf '%s' "$selection" | cliphist delete
        notify-send -t 1200 "Clipboard" "Entry deleted"
        ;;
esac
