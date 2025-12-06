#!/bin/bash
# matugen-hook.sh - Called by kde-material-you-colors on wallpaper/color change
# Generates Emacs and GTK themes using the same seed color

set -e

# JSON file where kde-material-you-colors stores its color data
KDE_COLORS_JSON="/tmp/kde-material-you-colors-$(whoami).json"

# Wait briefly for the JSON to be written
sleep 0.5

# Extract seed color from kde-material-you-colors
if [[ -f "$KDE_COLORS_JSON" ]]; then
    SEED_COLOR=$(jq -r '.seed.color' "$KDE_COLORS_JSON" 2>/dev/null)
else
    echo "kde-material-you-colors JSON not found: $KDE_COLORS_JSON" >&2
    exit 1
fi

if [[ -z "$SEED_COLOR" || "$SEED_COLOR" == "null" ]]; then
    echo "Could not extract seed color from JSON" >&2
    exit 1
fi

# Detect light/dark mode from system settings
COLOR_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null | tr -d "'")
if [[ "$COLOR_SCHEME" == "prefer-dark" ]]; then
    MODE="dark"
else
    MODE="light"
fi

# Run matugen with the seed color
# This generates templates for Emacs, GTK-3.0, and GTK-4.0
matugen color hex "$SEED_COLOR" --mode "$MODE" --quiet

echo "matugen-hook: Updated Emacs and GTK themes with color $SEED_COLOR (mode: $MODE)"
