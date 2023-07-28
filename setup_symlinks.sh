#!/usr/bin/env bash

CURRENT_DIR=$(pwd)

# Top level files
ln -s $CURRENT_DIR/bash-preexec.sh $HOME/bash-preexec.sh
ln -s $CURRENT_DIR/bashrc.sh $HOME/.bashrc
ln -s $CURRENT_DIR/gdbinit.gdb $HOME/.gtbinit
ln -s $CURRENT_DIR/prompt.sh $HOME/prompt.sh

# Emacs
mkdir -p $HOME/.emacs.d
ln -s $CURRENT_DIR/emacs.d/init.el $HOME/.emacs.d/init.el
ln -s $CURRENT_DIR/emacs.d/custom-file.el $HOME/.emacs.d/custom-file.el

# GnuPG
mkdir -p $HOME/.gnupg
ln -s $CURRENT_DIR/gnupg/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf
ln -s $CURRENT_DIR/gnupg/gpg.conf $HOME/.gnupg/gpg.conf

# Other configs
mkdir -p $HOME/.config
ln -s $CURRENT_DIR/config/awesome $HOME/.config/awesome
ln -s $CURRENT_DIR/config/emacs $HOME/.config/emacs
ln -s $CURRENT_DIR/config/kitty $HOME/.config/kitty
ln -s $CURRENT_DIR/config/picom $HOME/.config/picom
ln -s $CURRENT_DIR/config/terminator $HOME/.config/terminator
