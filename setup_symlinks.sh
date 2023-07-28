#!/usr/bin/env bash

CURRENT_DIR=$(pwd)

# Top level files
ln -sf "$CURRENT_DIR/bash-preexec.sh" "$HOME/bash-preexec.sh"
ln -sf "$CURRENT_DIR/bashrc.sh" "$HOME/.bashrc"
ln -sf "$CURRENT_DIR/gdbinit.gdb" "$HOME/.gtbinit"
ln -sf "$CURRENT_DIR/prompt.sh" "$HOME/prompt.sh"

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
