#!/usr/bin/env bash
#
# Arch Linux package installation script
# For KDE Plasma Wayland setup
#

set -e

echo "Installing packages for Arch Linux with KDE Plasma Wayland..."
echo ""

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "Error: yay (AUR helper) is not installed."
    echo "Install yay first: https://github.com/Jguer/yay"
    exit 1
fi

# Core Desktop Environment
echo "==> Installing KDE Plasma and SDDM..."
yay -S --needed plasma-meta sddm

# Shell and Terminal
echo "==> Installing shell tools..."
yay -S --needed bash bash-completion starship kitty

# Editor
echo "==> Installing Emacs..."
yay -S --needed emacs

# Input Method (Fcitx5)
echo "==> Installing Fcitx5..."
yay -S --needed fcitx5 fcitx5-configtool fcitx5-qt fcitx5-gtk
# Optional: Add language support as needed
# yay -S --needed fcitx5-hangul fcitx5-chinese-addons

# Fonts
echo "==> Installing fonts..."
yay -S --needed \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \
    ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols-mono

# Audio (PipeWire)
echo "==> Installing audio packages..."
yay -S --needed pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils

# Bluetooth
echo "==> Installing Bluetooth support..."
yay -S --needed bluez bluez-utils
sudo systemctl enable bluetooth.service

# File Sync
echo "==> Installing Syncthing..."
yay -S --needed syncthing

# Development Tools
echo "==> Installing development tools..."
yay -S --needed git base-devel rust cargo gpg jq

# Symlink Management
echo "==> Installing GNU Stow..."
yay -S --needed stow

# Material You Theming
echo "==> Installing Material You theming tools..."
yay -S --needed kde-material-you-colors matugen-bin

# Optional: Photo management
echo "==> Installing optional packages..."
yay -S --needed digikam

# Graphics (NVIDIA)
echo ""
read -p "Do you want to install NVIDIA drivers? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "==> Installing NVIDIA drivers..."
    yay -S --needed nvidia-dkms nvidia-utils nvidia-settings nvidia-prime
    echo "Note: You may need to configure /etc/modprobe.d/nvidia.conf for Wayland support"
    echo "      See: dotfiles/system/modprobe.d/nvidia.conf (reference)"
else
    echo "Skipping NVIDIA drivers installation."
fi

echo ""
echo "✓ Package installation complete!"
echo ""
echo "Next steps:"
echo "  1. Remove existing configs that conflict with stow:"
echo "     rm ~/.bashrc ~/.gdbinit ~/.asound.conf ~/bash-preexec.sh"
echo "     rm -rf ~/.config/emacs ~/.config/kitty ~/.config/pulse"
echo "     rm -rf ~/.config/matugen ~/.config/kde-material-you-colors"
echo "  2. Run ./stow.sh to set up dotfiles"
echo "  3. Build sort_pictures:"
echo "     cd sort_pictures && cargo build --release"
echo "     mkdir -p ~/apps/bin && cp target/release/sort_pictures ~/apps/bin/"
echo "  4. Install SDDM config: cd sddm && ./install_sddm.sh"
echo "  5. Enable SDDM: sudo systemctl enable sddm"
echo "  6. Enable kde-material-you-colors autostart:"
echo "     kde-material-you-colors --autostart"
echo "  7. Enable user services:"
echo "     systemctl --user enable --now syncthing.service"
echo "     systemctl --user enable --now sort_pictures.service"
echo "  8. Reboot to start using KDE Plasma"
