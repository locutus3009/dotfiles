#!/usr/bin/env bash
#
# Arch Linux package installation script
# For KDE Plasma Wayland setup
#

set -e

# =============================================================================
# Package Definitions
# =============================================================================

# Core Desktop Environment
PACKAGES_DESKTOP=(plasma-meta sddm)

# Shell and Terminal
PACKAGES_SHELL=(bash bash-completion starship kitty)

# Editor
PACKAGES_EDITOR=(emacs)

# Input Method (Fcitx5)
PACKAGES_INPUT=(fcitx5 fcitx5-configtool fcitx5-qt fcitx5-gtk)

# Fonts
PACKAGES_FONTS=(
    noto-fonts noto-fonts-cjk noto-fonts-emoji
    ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols-mono
)

# Audio (PipeWire)
PACKAGES_AUDIO=(pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils)

# Bluetooth
PACKAGES_BLUETOOTH=(bluez bluez-utils)


# Development Tools
PACKAGES_DEV=(git base-devel rust cargo gnupg jq)

# Symlink Management
PACKAGES_STOW=(stow)

# Optional packages
PACKAGES_OPTIONAL=(digikam)

# =============================================================================
# Functions
# =============================================================================

get_missing_packages() {
    local packages=("$@")
    local missing=()

    for pkg in "${packages[@]}"; do
        if ! yay -Q "$pkg" &>/dev/null; then
            missing+=("$pkg")
        fi
    done

    echo "${missing[@]}"
}

install_packages() {
    local packages=("$@")

    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi

    yay -S --needed "${packages[@]}"
}

# =============================================================================
# Main Script
# =============================================================================

echo "Arch Linux Package Installer for KDE Plasma Wayland"
echo "===================================================="
echo ""

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "Error: yay (AUR helper) is not installed."
    echo "Install yay first: https://github.com/Jguer/yay"
    exit 1
fi

# Combine all standard packages
ALL_PACKAGES=(
    "${PACKAGES_DESKTOP[@]}"
    "${PACKAGES_SHELL[@]}"
    "${PACKAGES_EDITOR[@]}"
    "${PACKAGES_INPUT[@]}"
    "${PACKAGES_FONTS[@]}"
    "${PACKAGES_AUDIO[@]}"
    "${PACKAGES_BLUETOOTH[@]}"
    "${PACKAGES_DEV[@]}"
    "${PACKAGES_STOW[@]}"
    "${PACKAGES_OPTIONAL[@]}"
)

echo "Checking ${#ALL_PACKAGES[@]} packages..."
echo ""

# Find missing packages
MISSING=($(get_missing_packages "${ALL_PACKAGES[@]}"))

if [[ ${#MISSING[@]} -eq 0 ]]; then
    echo "✓ All packages already installed."
else
    echo "Missing packages (${#MISSING[@]}):"
    echo "  ${MISSING[*]}"
    echo ""
    echo "Installing missing packages..."
    echo ""
    install_packages "${MISSING[@]}"
    echo ""
    echo "✓ Package installation complete!"
fi

# Enable bluetooth if bluez was just installed
if [[ " ${MISSING[*]} " =~ " bluez " ]]; then
    echo ""
    echo "Enabling Bluetooth service..."
    sudo systemctl enable bluetooth.service
fi

# =============================================================================
# System Configuration
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# SDDM configuration
SDDM_CONF_SRC="$SCRIPT_DIR/sddm/kde_settings.conf"
SDDM_CONF_DST="/etc/sddm.conf.d/kde_settings.conf"

if [[ -f "$SDDM_CONF_SRC" ]]; then
    if [[ -f "$SDDM_CONF_DST" ]] && cmp -s "$SDDM_CONF_SRC" "$SDDM_CONF_DST"; then
        echo ""
        echo "✓ SDDM config already installed."
    else
        echo ""
        read -p "Install SDDM configuration? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing SDDM config..."
            sudo mkdir -p /etc/sddm.conf.d
            sudo cp "$SDDM_CONF_SRC" "$SDDM_CONF_DST"
            sudo chmod 644 "$SDDM_CONF_DST"
            echo "✓ SDDM config installed."
        else
            echo "Skipping SDDM config."
        fi
    fi
fi

# Enable SDDM service
if ! systemctl is-enabled sddm.service &>/dev/null; then
    echo ""
    read -p "Enable SDDM service? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo systemctl enable sddm.service
        echo "✓ SDDM service enabled."
    else
        echo "Skipping SDDM service enablement."
    fi
else
    echo ""
    echo "✓ SDDM service already enabled."
fi

# =============================================================================
# Build Rust Binaries (BEFORE stow - binaries go into stow/apps/apps/bin/)
# =============================================================================

echo ""
echo "===================================================="
echo "Building Rust binaries..."
echo ""
echo "Note: Binaries are built into stow/apps/apps/bin/ and then"
echo "symlinked to ~/apps/bin/ via stow. You must build before stow."
echo ""

APPS_BIN_DIR="$SCRIPT_DIR/stow/apps/apps/bin"
mkdir -p "$APPS_BIN_DIR"

# Build sort_pictures
SORT_PICTURES_DIR="$SCRIPT_DIR/sort_pictures"
SORT_PICTURES_BIN="$APPS_BIN_DIR/sort_pictures"

if [[ -d "$SORT_PICTURES_DIR" ]] && command -v cargo &>/dev/null; then
    read -p "Build sort_pictures? (Y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo "Building sort_pictures..."
        (cd "$SORT_PICTURES_DIR" && cargo build --release)

        # Stop service if running (binary may be locked)
        if systemctl --user is-active sort_pictures.service &>/dev/null; then
            echo "Stopping sort_pictures service..."
            systemctl --user stop sort_pictures.service
        fi

        cp "$SORT_PICTURES_DIR/target/release/sort_pictures" "$SORT_PICTURES_BIN"
        echo "✓ sort_pictures built to stow/apps/apps/bin/"
    else
        echo "Skipping sort_pictures build."
    fi
fi

# Build sportmodel
SPORTMODEL_DIR="$SCRIPT_DIR/sportmodel"
SPORTMODEL_BIN="$APPS_BIN_DIR/sportmodel"

if [[ -d "$SPORTMODEL_DIR" ]] && command -v cargo &>/dev/null; then
    echo ""
    read -p "Build sportmodel? (Y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo "Building sportmodel..."
        (cd "$SPORTMODEL_DIR" && cargo build --release)

        # Stop service if running (binary may be locked)
        if systemctl --user is-active sportmodel.service &>/dev/null; then
            echo "Stopping sportmodel service..."
            systemctl --user stop sportmodel.service
        fi

        cp "$SPORTMODEL_DIR/target/release/sportmodel" "$SPORTMODEL_BIN"
        echo "✓ sportmodel built to stow/apps/apps/bin/"
    else
        echo "Skipping sportmodel build."
    fi
fi

# =============================================================================
# Stow Dotfiles
# =============================================================================

echo ""
echo "===================================================="
echo "Setting up dotfiles with GNU Stow..."
echo ""

# Warn about conflicting files
echo "Note: Stow will fail if these files exist:"
echo "  ~/.bashrc ~/.gdbinit ~/.asound.conf ~/bash-preexec.sh"
echo "  ~/.config/emacs ~/.config/kitty ~/.config/pulse"
echo ""
read -p "Run stow.sh to set up dotfiles? (Y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    if "$SCRIPT_DIR/stow.sh"; then
        echo ""
        echo "✓ Dotfiles installed successfully!"

        # Enable systemd services after stow creates the service files
        echo ""
        echo "Enabling systemd services..."

        if [[ -f "$HOME/.config/systemd/user/sort_pictures.service" ]]; then
            systemctl --user daemon-reload
            systemctl --user enable --now sort_pictures.service
            echo "✓ sort_pictures service enabled."
        fi

        if [[ -f "$HOME/.config/systemd/user/sportmodel.service" ]]; then
            systemctl --user daemon-reload
            systemctl --user enable --now sportmodel.service
            echo "✓ sportmodel service enabled."
        fi
    else
        echo ""
        echo "✗ Stow failed. Remove conflicting files and run ./stow.sh manually."
    fi
else
    echo "Skipping stow. Run ./stow.sh manually when ready."
fi

echo ""
echo "===================================================="
echo "Next steps:"
echo "  1. Reboot to start using KDE Plasma"
