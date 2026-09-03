#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/rofi_menu.sh"

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/waybar"
LAST_VPN_FILE="${CACHE_DIR}/last_vpn"
mkdir -p "${CACHE_DIR}"

get_active_vpn() {
    nmcli -g NAME,TYPE connection show --active 2>/dev/null | awk -F: '$2 ~ /^(wireguard|vpn|tun|openvpn)$/ && $1 !~ /^(docker|br-|tailscale)/ { print $1 }' | head -n1 || true
}

get_all_vpns() {
    nmcli -g NAME,TYPE connection show 2>/dev/null | awk -F: '$2 ~ /^(wireguard|vpn|tun|openvpn)$/ && $1 !~ /^(docker|br-|tailscale)/ { print $1 }' | sort -u || true
}

status() {
    local active_vpn
    active_vpn="$(get_active_vpn)"

    if [[ -n "${active_vpn}" ]]; then
        printf '{"text": "󰌾 %s", "class": "connected", "tooltip": "VPN: %s (Connected)\\nClick to manage"}\n' "${active_vpn}" "${active_vpn}"
    else
        printf '{"text": "󰌿  VPN Off", "class": "disconnected", "tooltip": "VPN: Disconnected\\nClick to connect"}\n'
    fi
}

menu() {
    local active_vpn all_vpns last_vpn options=""
    active_vpn="$(get_active_vpn)"
    all_vpns="$(get_all_vpns)"
    last_vpn=""

    if [[ -f "${LAST_VPN_FILE}" ]]; then
        last_vpn="$(cat "${LAST_VPN_FILE}" 2>/dev/null || true)"
    fi

    if [[ -z "${all_vpns}" ]]; then
        notify-send -a "VPN" "VPN" "No VPN connections found in NetworkManager"
        return 0
    fi

    local lines=0

    if [[ -n "${active_vpn}" ]]; then
        options+="disconnect"$'\t'"󰅖  Disconnect (${active_vpn})"$'\n'
        options+="retry"$'\t'"󰑐  Reconnect (${active_vpn})"$'\n'
        ((lines+=2))
    elif [[ -n "${last_vpn}" ]]; then
        options+="retry"$'\t'"󰑐  Retry (${last_vpn})"$'\n'
        ((lines+=1))
    fi

    while IFS= read -r vpn; do
        [[ -z "${vpn}" ]] && continue
        if [[ "${vpn}" == "${active_vpn}" ]]; then
            options+="vpn_${vpn}"$'\t'"󰒄  ${vpn} (Active)"$'\n'
        else
            options+="vpn_${vpn}"$'\t'"󰌾  ${vpn}"$'\n'
        fi
        ((lines+=1))
    done <<< "${all_vpns}"

    options="${options%$'\n'}"

    local choice_text choice_key
    choice_text=$(printf '%s\n' "$options" | cut -f2 | rofi_run vpn -dmenu -p "VPN" -i -no-custom -l "${lines}")

    if [[ -z "${choice_text}" ]]; then
        return 0
    fi

    choice_key=$(printf '%s\n' "$options" | awk -F'\t' -v selected="$choice_text" '$2 == selected { print $1; exit }')

    case "$choice_key" in
        disconnect)
            if [[ -n "${active_vpn}" ]]; then
                printf '%s' "${active_vpn}" > "${LAST_VPN_FILE}"
                nmcli connection down "${active_vpn}" >/dev/null 2>&1 || true
                notify-send -a "VPN" "VPN" "Disconnected from ${active_vpn}"
            fi
            ;;
        retry)
            local target_vpn="${active_vpn:-$last_vpn}"
            if [[ -z "${target_vpn}" ]]; then
                target_vpn="$(head -n1 <<< "${all_vpns}")"
            fi

            if [[ -n "${active_vpn}" ]]; then
                nmcli connection down "${active_vpn}" >/dev/null 2>&1 || true
            fi

            if nmcli connection up "${target_vpn}" >/dev/null 2>&1; then
                printf '%s' "${target_vpn}" > "${LAST_VPN_FILE}"
                notify-send -a "VPN" "VPN Connected" "Connected to ${target_vpn}"
            else
                printf '%s' "${target_vpn}" > "${LAST_VPN_FILE}"
                notify-send -u critical -a "VPN" "VPN Connection Failed" "Could not connect to ${target_vpn}"
            fi
            ;;
        vpn_*)
            local selected_vpn="${choice_key#vpn_}"
            if [[ "${selected_vpn}" == "${active_vpn}" ]]; then
                printf '%s' "${selected_vpn}" > "${LAST_VPN_FILE}"
                nmcli connection down "${selected_vpn}" >/dev/null 2>&1 || true
                notify-send -a "VPN" "VPN" "Disconnected from ${selected_vpn}"
            else
                if [[ -n "${active_vpn}" ]]; then
                    nmcli connection down "${active_vpn}" >/dev/null 2>&1 || true
                fi
                if nmcli connection up "${selected_vpn}" >/dev/null 2>&1; then
                    printf '%s' "${selected_vpn}" > "${LAST_VPN_FILE}"
                    notify-send -a "VPN" "VPN Connected" "Connected to ${selected_vpn}"
                else
                    printf '%s' "${selected_vpn}" > "${LAST_VPN_FILE}"
                    notify-send -u critical -a "VPN" "VPN Connection Failed" "Could not connect to ${selected_vpn}"
                fi
            fi
            ;;
    esac

    pkill -RTMIN+8 waybar 2>/dev/null || true
}

case "${1:-}" in
    --menu)
        menu
        ;;
    *)
        status
        ;;
esac
