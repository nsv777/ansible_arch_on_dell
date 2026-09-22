#!/usr/bin/env bash
# Download and set random wallpaper
# Arguments:
# - python binary
# - script location
# - optional GSettings wallpaper parameter
#
# On Hyprland, the script discovers an active Hyprland socket and sets the
# fallback wallpaper through hyprpaper. Other sessions use GSettings.

set -euo pipefail

tempfile=$(mktemp)
wallpaper_file_prefix="/var/tmp/background_$(date +%s)"

cleanup() {
  rm -f "${tempfile}"
}

trap cleanup EXIT

PYTHON_BINARY="${1:?Error: Python binary path is required as the first argument.}"
SCRIPT_PATH="${2:?Error: Script path is required as the second argument.}"
GSETTINGS_WALLPAPER_PARAMETER="${3:-}"

WALLPAPER_URL=$("${PYTHON_BINARY}" "${SCRIPT_PATH}")

wget -q --limit-rate=50k -O "${tempfile}" "${WALLPAPER_URL}"

# Checking the file type. It is not always jpeg
# taking the second part of image/png or image/jpeg
file_type=$(file --brief --mime-type "${tempfile}" | cut -d '/' -f2)
# Rename temp file accordingly
wallpaper_file="${wallpaper_file_prefix}.${file_type}"
cp "${tempfile}" "${wallpaper_file}"

set_hyprpaper_wallpaper() {
  local hyprland_instance

  command -v hyprctl >/dev/null 2>&1 || return 1

  if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] && \
    hyprctl hyprpaper wallpaper ",${wallpaper_file}"; then
    return 0
  fi

  [[ -n "${XDG_RUNTIME_DIR:-}" ]] || return 1

  for hyprland_instance in "${XDG_RUNTIME_DIR:-}/hypr/"*; do
    [[ -S "${hyprland_instance}/.socket.sock" ]] || continue

    HYPRLAND_INSTANCE_SIGNATURE="${hyprland_instance##*/}" \
      hyprctl hyprpaper wallpaper ",${wallpaper_file}" && return 0
  done

  return 1
}

set_gsettings_wallpaper() {
  if [[ -z "${GSETTINGS_WALLPAPER_PARAMETER}" ]]; then
    printf '%s\n' 'Error: GSettings wallpaper parameter is required when hyprpaper is unavailable.' >&2
    return 1
  fi

  export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
  # Force refresh; GSettings otherwise keeps the wallpaper when its file changes.
  gsettings set "${GSETTINGS_WALLPAPER_PARAMETER}" picture-uri "file://${tempfile}"
  gsettings set "${GSETTINGS_WALLPAPER_PARAMETER}" picture-uri "file://${wallpaper_file}"
}

set_hyprpaper_wallpaper || set_gsettings_wallpaper
