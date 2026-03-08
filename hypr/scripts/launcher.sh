#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/rofi_menu.sh"

exec rofi \
    -config "${SCRIPT_DIR}/../../rofi/config.rasi" \
    -show drun \
    -display-drun "Applications" \
    -show-icons \
    -theme-str "$(rofi_theme_override launcher)"
