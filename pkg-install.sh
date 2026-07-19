#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0

DEB_PKGS=("${DOTFILES_DIR}/pkgs.deb.txt" "${DOTFILES_DIR}/other_pkgs.deb.txt")
RPM_PKGS=("${DOTFILES_DIR}/pkgs.rpm.txt" "${DOTFILES_DIR}/other_pkgs.rpm.txt")
ARCH_PKGS=("${DOTFILES_DIR}/pkgs.arch.txt" "${DOTFILES_DIR}/other_pkgs.arch.txt")

log()  { echo "[pkg-install] $*"; }
warn() { echo "[pkg-install][WARN] $*" >&2; }
die()  { echo "[pkg-install][ERROR] $*" >&2; exit 1; }

confirm() {
    local prompt="$1"
    local ans
    printf "%s [y/N] " "$prompt"
    read -r ans
    case "$ans" in
        y|Y|yes|YES) return 0 ;;
        *) return 1 ;;
    esac
}

detect_distro() {
    if [ -r /etc/os-release ]; then
        . /etc/os-release
        echo "${ID:-unknown}"
    else
        die "Cannot read /etc/os-release"
    fi
}

install_arch() {
    log "Detected Arch-based distro."
    local aur_helper=""
    if command -v yay >/dev/null 2>&1; then
        aur_helper="yay"
    elif command -v paru >/dev/null 2>&1; then
        aur_helper="paru"
    else
        die "No AUR helper found (yay/paru). Install one first: https://wiki.archlinux.org/title/AUR_helpers"
    fi

    local pkgs
    pkgs="$(cat "${ARCH_PKGS[@]}" | grep -v '^$')"

    if ! confirm "Run system upgrade (sudo pacman -Syu)?"; then
        log "Skipping system upgrade."
    elif [ "$DRY_RUN" -eq 1 ]; then
        log "[dry-run] would run: sudo pacman -Syu"
    else
        sudo pacman -Syu --noconfirm
    fi

    if ! confirm "Install AUR packages via $aur_helper?"; then
        log "Skipping AUR package install."
        return 0
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        log "[dry-run] would run: $aur_helper -S --needed $pkgs"
    else
        "$aur_helper" -S --needed $pkgs
    fi
}

install_deb() {
    log "Detected Debian/Ubuntu."

    if ! confirm "Run apt update + upgrade?"; then
        log "Skipping apt update/upgrade."
    elif [ "$DRY_RUN" -eq 0 ]; then
        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y xdg-utils curl wget ca-certificates gnupg lsb-release
    else
        log "[dry-run] would run: apt update && apt upgrade -y"
    fi

    local bare
    bare="$(cat "${DEB_PKGS[@]}" | grep -v '^$')"

    if ! confirm "Install packages from pkgs.deb.txt + other_pkgs.deb.txt?"; then
        log "Skipping apt package install."
        return 0
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        log "[dry-run] would apt install:"
        echo "$bare" | while read -r p; do log "  $p"; done
    else
        local to_install=()
        while IFS= read -r p; do
            if apt-cache show "$p" >/dev/null 2>&1; then
                to_install+=("$p")
            else
                warn "Package '$p' not found in apt repos; skipping. (AUR-only on Arch -> install manually)"
            fi
        done <<< "$bare"
        if [ "${#to_install[@]}" -gt 0 ]; then
            sudo apt install -y "${to_install[@]}"
        fi
    fi
}

install_rpm() {
    log "Detected Fedora."

    if ! confirm "Run system upgrade (sudo dnf upgrade)?"; then
        log "Skipping system upgrade."
    elif [ "$DRY_RUN" -eq 0 ]; then
        sudo dnf upgrade -y
    else
        log "[dry-run] would run: sudo dnf upgrade -y"
    fi

    if confirm "Enable RPM Fusion free+nonfree and solopasha/hyprland COPR?"; then
        if [ "$DRY_RUN" -eq 0 ]; then
            if ! rpm -q rpmfusion-free-release >/dev/null 2>&1; then
                log "Enabling RPM Fusion free..."
                sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
            fi
            if ! rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
                log "Enabling RPM Fusion nonfree..."
                sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
            fi
            if ! dnf copr list 2>/dev/null | grep -q "solopasha/hyprland"; then
                log "Enabling solopasha/hyprland COPR..."
                sudo dnf copr enable -y solopasha/hyprland
            fi
        else
            log "[dry-run] would enable RPM Fusion + solopasha/hyprland COPR"
        fi
    else
        log "Skipping RPM Fusion / COPR enable."
    fi

    local bare
    bare="$(cat "${RPM_PKGS[@]}" | grep -v '^$')"

    if ! confirm "Install packages from pkgs.rpm.txt + other_pkgs.rpm.txt?"; then
        log "Skipping dnf package install."
        return 0
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        log "[dry-run] would dnf install:"
        echo "$bare" | while read -r p; do log "  $p"; done
    else
        local to_install=()
        while IFS= read -r p; do
            if dnf repoquery --quiet --installed "$p" >/dev/null 2>&1 || dnf repoquery --quiet "$p" >/dev/null 2>&1; then
                to_install+=("$p")
            else
                warn "Package '$p' not found in enabled repos; skipping. (AUR-only on Arch -> install manually)"
            fi
        done <<< "$bare"
        if [ "${#to_install[@]}" -gt 0 ]; then
            sudo dnf install -y "${to_install[@]}"
        fi
    fi
}

main() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --dry-run) DRY_RUN=1 ;;
            --help|-h)
                echo "Usage: $0 [--dry-run]"
                echo "Installs packages for the detected distro (Arch/Debian/Fedora)."
                echo "Each step prompts y/N so you can skip what you want."
                exit 0
                ;;
            *) die "Unknown argument: $1 (try --help)" ;;
        esac
        shift
    done

    local distro
    distro="$(detect_distro)"
    log "Detected distro ID: $distro"

    case "$distro" in
        arch|endeavouros|manjaro|garuda|cachyos) install_arch ;;
        debian|ubuntu|linuxmint|pop|zorin) install_deb ;;
        fedora) install_rpm ;;
        *) die "Unsupported distro: $distro. Edit pkg-install.sh to add support." ;;
    esac

    log "Package installation step complete."
    log "Remember to run ./install-conf.sh afterwards to symlink your config files."
}

main "$@"
