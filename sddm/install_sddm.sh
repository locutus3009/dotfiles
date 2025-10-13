#!/usr/bin/env bash
#
# Install SDDM configuration
# Requires sudo privileges
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDDM_CONF_DIR="/etc/sddm.conf.d"

echo "Installing SDDM configuration..."

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "Error: Do not run this script as root. It will ask for sudo when needed."
    exit 1
fi

# Create SDDM config directory if it doesn't exist
if [ ! -d "$SDDM_CONF_DIR" ]; then
    echo "Creating $SDDM_CONF_DIR..."
    sudo mkdir -p "$SDDM_CONF_DIR"
fi

# Copy SDDM configuration
echo "Copying kde_settings.conf to $SDDM_CONF_DIR..."
sudo cp "$SCRIPT_DIR/kde_settings.conf" "$SDDM_CONF_DIR/kde_settings.conf"
sudo chmod 644 "$SDDM_CONF_DIR/kde_settings.conf"

echo "✓ SDDM configuration installed successfully!"
echo ""
echo "Note: Changes will take effect on next login/reboot."
echo "Current SDDM settings:"
echo "  - Theme: Breeze"
echo "  - Cursor: breeze_cursors"
echo "  - Font: Noto Sans 10pt"
