#!/usr/bin/env bash
set -euo pipefail

ORIGIN_DIR="${XDG_RUNTIME_DIR:-/tmp}/hypr_scratchpad_origins"
mkdir -p "${ORIGIN_DIR}"

stash_toggle() {
  local active_win win_addr win_ws target_ws
  active_win="$(hyprctl activewindow -j 2>/dev/null || echo "{}")"
  win_addr="$(echo "$active_win" | jq -r '.address // empty')"
  win_ws="$(echo "$active_win" | jq -r '.workspace.name // empty')"

  [[ -z "$win_addr" ]] && return 0

  if [[ "$win_ws" =~ ^special: ]]; then
    target_ws=""
    if [[ -f "${ORIGIN_DIR}/${win_addr}" ]]; then
      target_ws="$(cat "${ORIGIN_DIR}/${win_addr}" 2>/dev/null || true)"
      rm -f "${ORIGIN_DIR}/${win_addr}"
    fi
    if [[ -z "$target_ws" ]]; then
      target_ws="$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.name // "1"')"
    fi
    hyprctl dispatch "hl.dsp.window.move({ window = \"address:${win_addr}\", workspace = \"${target_ws}\" })" >/dev/null 2>&1 || true
  else
    printf '%s' "$win_ws" > "${ORIGIN_DIR}/${win_addr}"
    hyprctl dispatch "hl.dsp.window.move({ window = \"address:${win_addr}\", workspace = \"special\", silent = true })" >/dev/null 2>&1 || true
  fi
}

case "${1:-}" in
  --toggle)
    hyprctl dispatch 'hl.dsp.workspace.toggle_special("")' >/dev/null 2>&1 || true
    ;;
  --stash)
    stash_toggle
    ;;
  *)
    hyprctl clients -j 2>/dev/null | jq -c '
      [.[] | select(.workspace.name | startswith("special:"))] as $sp |
      if ($sp | length) > 0 then
        {
          text: ("󱂬  " + ($sp | length | tostring)),
          class: "active",
          tooltip: ("Scratchpad (" + ($sp | length | tostring) + " windows):\n" + ($sp | map("• " + .title) | join("\n")))
        }
      else
        {
          text: "󱂬  0",
          class: "empty",
          tooltip: "Scratchpad is empty"
        }
      end
    ' || printf '{"text":"󱂬 0","class":"empty","tooltip":"Scratchpad is empty"}\n'
    ;;
esac
