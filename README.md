# Personal dotfiles repository

## Idea

Inspired by [this tutorial][https://www.atlassian.com/git/tutorials/dotfiles]

## Quick setup

Setup alias:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Close repository:

```bash
git clone --bare https://github.com/locutus3009/dotfiles $HOME/.cfg
```

Checkout:

```bash
config checkout
config config --local status.showUntrackedFiles no
```
