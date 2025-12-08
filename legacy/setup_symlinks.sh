#!/usr/bin/env bash

CURRENT_DIR=$(pwd)

# Top level files
ln -sf "$CURRENT_DIR/bashrc.dot.sh" "$HOME/.bashrc"
ln -sf "$CURRENT_DIR/gdbinit.dot" "$HOME/.gdbinit"
ln -sf "$CURRENT_DIR/asound.conf.dot" "$HOME/.asound.conf"
ln -sf "$CURRENT_DIR/bash-preexec.sh" "$HOME/bash-preexec.sh"

# X config (archived - using KDE Plasma Wayland now)
# ln -sf "$CURRENT_DIR/legacy/xbindkeysrc.dot" "$HOME/.xbindkeysrc"
# ln -sf "$CURRENT_DIR/legacy/Xdefaults.dot" "$HOME/.Xdefaults"
# ln -sf "$CURRENT_DIR/legacy/Xmodmap.dot" "$HOME/.Xmodmap"
# ln -sf "$CURRENT_DIR/legacy/xprofile.dot" "$HOME/.xprofile"
# ln -sf "$CURRENT_DIR/legacy/xinitrc.dot" "$HOME/.xinitrc"

# Emacs
mkdir -p "$HOME/.emacs.d"
ln -sf "$CURRENT_DIR/emacs.d/init.el" "$HOME/.emacs.d/init.el"

# GnuPG
mkdir -p "$HOME/.gnupg"
ln -sf "$CURRENT_DIR/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
ln -sf "$CURRENT_DIR/gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"

# Active configs
mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/emacs"
ln -sf "$CURRENT_DIR/config/emacs" "$HOME/.config/emacs"
rm -rf "$HOME/.config/kitty"
ln -sf "$CURRENT_DIR/config/kitty" "$HOME/.config/kitty"
rm -rf "$HOME/.config/pulse"
ln -sf "$CURRENT_DIR/config/pulse" "$HOME/.config/pulse"

# KDE Plasma configs (selective - key configs only)
ln -sf "$CURRENT_DIR/config/plasma/kdeglobals" "$HOME/.config/kdeglobals"
ln -sf "$CURRENT_DIR/config/plasma/kwinrc" "$HOME/.config/kwinrc"
ln -sf "$CURRENT_DIR/config/plasma/kwinrulesrc" "$HOME/.config/kwinrulesrc"
ln -sf "$CURRENT_DIR/config/plasma/kglobalshortcutsrc" "$HOME/.config/kglobalshortcutsrc"
ln -sf "$CURRENT_DIR/config/plasma/plasmashellrc" "$HOME/.config/plasmashellrc"

# Archived configs (no longer in use)
# rm -rf "$HOME/.config/awesome"
# ln -sf "$CURRENT_DIR/legacy/config/awesome" "$HOME/.config/awesome"
# rm -rf "$HOME/.config/picom"
# ln -sf "$CURRENT_DIR/legacy/config/picom" "$HOME/.config/picom"
# rm -rf "$HOME/.config/terminator"
# ln -sf "$CURRENT_DIR/legacy/config/terminator" "$HOME/.config/terminator"
# rm -rf "$HOME/.config/ranger"
# ln -sf "$CURRENT_DIR/legacy/config/ranger" "$HOME/.config/ranger"
# rm -rf "$HOME/.config/ncmpcpp"
# ln -sf "$CURRENT_DIR/legacy/config/ncmpcpp" "$HOME/.config/ncmpcpp"
# rm -rf "$HOME/.config/mpd"
# ln -sf "$CURRENT_DIR/legacy/config/mpd" "$HOME/.config/mpd"
# rm -rf "$HOME/.config/mopidy"
# ln -sf "$CURRENT_DIR/legacy/config/mopidy" "$HOME/.config/mopidy"

# Additional scripts
mkdir -p "$HOME/apps"
rm -rf "$HOME/apps/bin"
ln -sf "$CURRENT_DIR/apps/bin" "$HOME/apps/bin"

# Sort_pictures systemd service
mkdir -p "$HOME/.config/systemd/user"
ln -sf "$CURRENT_DIR/sort_pictures/systemd/sort_pictures.service" "$HOME/.config/systemd/user/sort_pictures.service"
mkdir -p "$HOME/.config/sort_pictures"
ln -sf "$CURRENT_DIR/sort_pictures/systemd/config.toml" "$HOME/.config/sort_pictures/config.toml"

# Plasma widgets
mkdir -p "$HOME/.local/share/plasma/plasmoids"
rm -rf "$HOME/.local/share/plasma/plasmoids/com.github.victorballester7.titlebingwallpaper"
ln -sf "$CURRENT_DIR/local/share/plasma/plasmoids/com.github.victorballester7.titlebingwallpaper" "$HOME/.local/share/plasma/plasmoids/com.github.victorballester7.titlebingwallpaper"

echo ""
echo "Installation complete!"
echo ""
echo "Notes:"
echo "  - To build and install sort_pictures binary: cd $CURRENT_DIR/sort_pictures && ./install.sh"
echo "  - To install SDDM configuration (requires sudo): cd $CURRENT_DIR/sddm && ./install_sddm.sh"
echo "  - Plasma widgets installed. Restart plasmashell if needed: killall plasmashell && plasmashell &"
