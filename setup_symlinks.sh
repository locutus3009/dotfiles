#!/usr/bin/env bash

CURRENT_DIR=$(pwd)

# Top level files
ln -sf "$CURRENT_DIR/bashrc.dot.sh" "$HOME/.bashrc"
ln -sf "$CURRENT_DIR/gdbinit.dot" "$HOME/.gtbinit"
ln -sf "$CURRENT_DIR/asound.conf.dot" "$HOME/.asound.conf"
ln -sf "$CURRENT_DIR/bash-preexec.sh" "$HOME/bash-preexec.sh"

# X config
ln -sf "$CURRENT_DIR/xbindkeysrc.dot" "$HOME/.xbindkeysrc"
ln -sf "$CURRENT_DIR/Xdefaults.dot" "$HOME/.Xdefaults"
ln -sf "$CURRENT_DIR/Xmodmap.dot" "$HOME/.Xmodmap"
ln -sf "$CURRENT_DIR/xprofile.dot" "$HOME/.xprofile"
ln -sf "$CURRENT_DIR/xinitrc.dot" "$HOME/.xinitrc"

# Emacs
mkdir -p "$HOME/.emacs.d"
ln -sf "$CURRENT_DIR/emacs.d/init.el" "$HOME/.emacs.d/init.el"

# GnuPG
mkdir -p "$HOME/.gnupg"
ln -sf "$CURRENT_DIR/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
ln -sf "$CURRENT_DIR/gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"

# Other configs
mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/awesome"
ln -sf "$CURRENT_DIR/config/awesome" "$HOME/.config/awesome"
rm -rf "$HOME/.config/emacs"
ln -sf "$CURRENT_DIR/config/emacs" "$HOME/.config/emacs"
rm -rf "$HOME/.config/kitty"
ln -sf "$CURRENT_DIR/config/kitty" "$HOME/.config/kitty"
rm -rf "$HOME/.config/picom"
ln -sf "$CURRENT_DIR/config/picom" "$HOME/.config/picom"
rm -rf "$HOME/.config/terminator"
ln -sf "$CURRENT_DIR/config/terminator" "$HOME/.config/terminator"
rm -rf "$HOME/.config/ranger"
ln -sf "$CURRENT_DIR/config/ranger" "$HOME/.config/ranger"
rm -rf "$HOME/.config/ncmpcpp"
ln -sf "$CURRENT_DIR/config/ncmpcpp" "$HOME/.config/ncmpcpp"
rm -rf "$HOME/.config/mpd"
ln -sf "$CURRENT_DIR/config/mpd" "$HOME/.config/mpd"
rm -rf "$HOME/.config/pulse"
ln -sf "$CURRENT_DIR/config/pulse" "$HOME/.config/pulse"

# Additional scripts
mkdir -p "$HOME/apps"
rm -rf "$HOME/apps/bin"
ln -sf "$CURRENT_DIR/apps/bin" "$HOME/apps/bin"
