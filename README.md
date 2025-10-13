# Dotfiles

Personal configuration files for Arch Linux with KDE Plasma (Wayland) and SDDM.

## System Setup

- **OS**: Arch Linux
- **Desktop Environment**: KDE Plasma 6
- **Display Server**: Wayland
- **Display Manager**: SDDM
- **Terminal**: Kitty
- **Shell**: Bash with Starship prompt
- **Editor**: Emacs (daemon mode with emacsclient)

## Installation

```bash
cd ~/dev/dotfiles
./setup_symlinks.sh
```

This will create symlinks from your home directory to the configuration files in this repository.

## Active Configurations

### Shell
- **bashrc.dot.sh** - Main bash configuration with aliases, environment variables, and Starship integration
- **bash-preexec.sh** - Shell hook library for executing commands before/after prompts

### Development Tools
- **emacs.d/init.el** - Emacs initialization file (simple bootstrap)
- **config/emacs/** - Full Emacs configuration directory
- **gdbinit.dot** - GDB debugger configuration

### Applications
- **config/kitty/** - Kitty terminal emulator configuration
- **config/pulse/** - PulseAudio configuration
- **gnupg/** - GPG and GPG-agent configuration (including SSH agent support)
- **asound.conf.dot** - ALSA audio configuration

### Utilities
- **apps/bin/** - Custom scripts and utilities

## Environment Variables

Key environment variables set in bashrc:

```bash
export DE='kde'
export XDG_CURRENT_DESKTOP=KDE
export EDITOR='emacsclient -c -nw -a emacs'  # Terminal editor
export VISUAL='emacsclient -c -a emacs'      # GUI editor
```

## GPG & SSH Agent

GPG agent is configured to handle SSH authentication. The setup in bashrc ensures:
- SSH uses GPG agent for key management
- GPG_TTY is properly set
- Agent socket is correctly configured at `/run/user/$UID/gnupg/S.gpg-agent.ssh`

## Emacs Aliases

Convenient aliases for working with Emacs in daemon mode:

```bash
cemacscli   # Terminal emacsclient
cmagit      # Terminal Magit
cagenda     # Terminal Org agenda
emacscli    # GUI emacsclient
magit       # GUI Magit
```

## Input Method

iBus is configured as the default input method framework:
- GLFW_IM_MODULE=ibus
- GTK_IM_MODULE=ibus
- QT_IM_MODULE=ibus
- XMODIFIERS=@im=ibus

## Archived Configurations (legacy/)

The following configurations are no longer actively used but preserved for reference:

### Window Managers & X11
- **legacy/config/awesome/** - AwesomeWM configuration (replaced by KDE Plasma)
- **legacy/config/picom/** - Picom X11 compositor (Wayland has built-in compositing)
- **legacy/xprofile.dot** - X11 session startup script
- **legacy/xinitrc.dot** - X11 initialization
- **legacy/Xdefaults.dot** - X resources
- **legacy/Xmodmap.dot** - X keyboard mappings
- **legacy/xbindkeysrc.dot** - X keybinding daemon config

### Unused Applications
- **legacy/config/ranger/** - Ranger file manager (using Dolphin/KDE file manager)
- **legacy/config/terminator/** - Terminator terminal (using Kitty)
- **legacy/config/mpd/** - Music Player Daemon (rarely used)
- **legacy/config/mopidy/** - Mopidy music server (rarely used)
- **legacy/config/ncmpcpp/** - ncmpcpp MPD client (rarely used)

## Directory Structure

```
dotfiles/
├── bashrc.dot.sh           # Bash configuration
├── bash-preexec.sh         # Shell hooks
├── asound.conf.dot         # ALSA config
├── gdbinit.dot            # GDB config
├── setup_symlinks.sh      # Installation script
├── install.sh             # Legacy install script
├── emacs.d/               # Emacs init
├── config/
│   ├── emacs/            # Main Emacs config
│   ├── kitty/            # Terminal config
│   ├── pulse/            # Audio config
│   └── wallpaper.JPG     # Desktop wallpaper
├── gnupg/
│   ├── gpg.conf          # GPG configuration
│   └── gpg-agent.conf    # GPG agent config
├── apps/
│   └── bin/              # Custom scripts
└── legacy/               # Archived configurations
    ├── config/           # Old app configs
    ├── xprofile.dot      # X11 session
    ├── xinitrc.dot       # X11 init
    ├── Xdefaults.dot     # X resources
    ├── Xmodmap.dot       # X keyboard
    └── xbindkeysrc.dot   # X keybindings
```

## Notes

- Symlinks are created using absolute paths from the dotfiles directory
- The repo is located at `/hdd/locutus/dev/dotfiles` with a symlink at `~/dev`
- Most personal data directories (Documents, Downloads, Music, etc.) are stored on `/hdd/locutus/`
- Bash history, GPG keys, and SSH keys are kept in home directory (not tracked)

## Maintenance

To update configs:
1. Edit files in the dotfiles repository
2. Commit changes: `git add . && git commit -m "Description"`
3. Changes are immediately active via symlinks

To restore configs on a new system:
1. Clone this repository to `~/dev/dotfiles`
2. Run `./setup_symlinks.sh`
3. Install required packages (Emacs, Kitty, Starship, etc.)
4. Restart shell or source `~/.bashrc`

## License

See LICENSE file for details.
