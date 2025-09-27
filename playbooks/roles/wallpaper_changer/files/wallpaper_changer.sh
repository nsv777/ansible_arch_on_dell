#!/usr/bin/env bash
# Download and set random wallpaper
# 2 arguments:
# - python binary
# - script location
# gsettings wallpaper parameter

set -euo pipefail

tempfile=$(mktemp)
wallpaper_file="/var/tmp/background.jpg"

PYTHON_BINARY="${1:?Error: Python binary path is required as the first argument.}"
SCRIPT_PATH="${2:?Error: Script path is required as the second argument.}"
GSETTINGS_WALLPAPER_PARAMETER="${3:?Error: GSettings wallpaper parameter is required as the third argument.}"

WALLPAPER_URL=$("${PYTHON_BINARY}" "${SCRIPT_PATH}")

wget -q --limit-rate=50k -O "${tempfile}" "${WALLPAPER_URL}"
mv "${tempfile}" "${wallpaper_file}"

PID=$(pgrep -f 'gnome-session' | head -n1)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ | cut -d= -f2-)
gsettings set "$GSETTINGS_WALLPAPER_PARAMETER" picture-uri "file://${wallpaper_file}"
