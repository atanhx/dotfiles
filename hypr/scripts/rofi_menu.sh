#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
ROFI_CONFIG="${DOTFILES_DIR}/rofi/config.rasi"

rofi_dmenu_list_theme() {
    printf '%s' 'element { children: [ element-text ]; } element-text { horizontal-align: 0.0; }'
}

rofi_icon_dmenu_list_theme() {
    printf '%s' 'element { children: [ element-icon, element-text ]; } element-icon { enabled: true; size: 1.4em; vertical-align: 0.5; } element-text { horizontal-align: 0.0; }'
}

rofi_heading_only_theme() {
    printf '%s' 'inputbar { children: [ prompt ]; } prompt { expand: true; horizontal-align: 0.5; }'
}

rofi_theme_override() {
    local preset=${1:?missing rofi preset}
    local dmenu_list_theme

    dmenu_list_theme="$(rofi_dmenu_list_theme)"

    case "$preset" in
        launcher)
            printf '%s' 'window { width: 420px; } listview { lines: 10; }'
            ;;
        power)
            printf '%s' "window { width: 230px; } listview { lines: 5; } ${dmenu_list_theme} $(rofi_heading_only_theme)"
            ;;
        clipboard-action)
            printf '%s' "window { width: 300px; } listview { lines: 3; } ${dmenu_list_theme} $(rofi_heading_only_theme)"
            ;;
        clipboard-confirm)
            printf '%s' "window { width: 280px; } listview { lines: 2; } ${dmenu_list_theme}"
            ;;
        clipboard-history)
            printf '%s' "window { width: 460px; } listview { lines: 6; } $(rofi_icon_dmenu_list_theme)"
            ;;
        capture)
            printf '%s' "window { width: 320px; } listview { lines: 5; } ${dmenu_list_theme} $(rofi_heading_only_theme)"
            ;;
        shell-history)
            printf '%s' "window { width: 520px; } listview { lines: 12; } ${dmenu_list_theme}"
            ;;
        shell-history-action)
            printf '%s' "window { width: 260px; } listview { lines: 2; } ${dmenu_list_theme} $(rofi_heading_only_theme)"
            ;;
        *)
            printf 'Unknown rofi preset: %s\n' "$preset" >&2
            return 1
            ;;
    esac
}

rofi_run() {
    local preset=${1:?missing rofi preset}
    shift

    rofi -config "${ROFI_CONFIG}" "$@" -theme-str "$(rofi_theme_override "$preset")"
}
