#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
PKG_LISTS=("${DOTFILES_DIR}/pkgs.arch.txt" "${DOTFILES_DIR}/other_pkgs.arch.txt")

log() { echo "[pkg-install] $*"; }
die() { echo "[pkg-install][ERROR] $*" >&2; exit 1; }

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        log "[dry-run] would run: $*"
    else
        "$@"
    fi
}

confirm() {
    printf "%s [y/N] " "$1"
    read -r ans
    [[ "$ans" =~ ^[yY](es)?$ ]]
}

aur_helper() {
    if command -v yay >/dev/null 2>&1; then echo yay; return; fi
    if command -v paru >/dev/null 2>&1; then echo paru; return; fi
    die "No AUR helper found (yay/paru). Install one first: https://wiki.archlinux.org/title/AUR_helpers"
}

main() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --dry-run) DRY_RUN=1 ;;
            -h|--help)
                echo "Usage: $0 [--dry-run]"
                echo "Installs packages from pkgs.arch.txt and other_pkgs.arch.txt via an AUR helper."
                exit 0 ;;
            *) die "Unknown argument: $1 (try --help)" ;;
        esac
        shift
    done

    local helper pkgs
    helper="$(aur_helper)"
    pkgs="$(cat "${PKG_LISTS[@]}")"
    log "Using AUR helper: $helper"

    if confirm "Run system upgrade (pacman -Syu)?"; then
        run sudo pacman -Syu --noconfirm
    fi

    if confirm "Install all packages from the lists?"; then
        run "$helper" -S --needed $pkgs
    fi

    log "Done. Next: ./install-conf.sh"
}

main "$@"
