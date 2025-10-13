# Dotfiles

Personal configuration files for Arch Linux with KDE Plasma (Wayland) and SDDM.

## System Setup

- **OS**: Arch Linux
- **Desktop Environment**: KDE Plasma 6
- **Display Server**: Wayland
- **Display Manager**: SDDM
- **Audio**: PipeWire (with PulseAudio compatibility)
- **Terminal**: Kitty
- **Shell**: Bash with Starship prompt
- **Editor**: Emacs (daemon mode with emacsclient)

## Installation

```bash
# Clone the repository
cd ~/dev
git clone <your-dotfiles-repo-url> dotfiles
cd dotfiles

# Initialize submodules
git submodule update --init --recursive

# Create symlinks
./setup_symlinks.sh
```

This will:
1. Initialize the sort_pictures submodule
2. Create symlinks from your home directory to the configuration files

**Note:** After running setup, build sort_pictures following the instructions in the Sort_pictures Service section.

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
- **config/pulse/** - Audio configuration (PipeWire uses PulseAudio config for compatibility)
- **gnupg/** - GPG and GPG-agent configuration (including SSH agent support)
- **asound.conf.dot** - ALSA audio configuration

### KDE Plasma Configuration

#### Core Plasma Configs
Selective tracking of key Plasma configs (portable, stable settings only):

- **config/plasma/kdeglobals** - Global KDE settings, theme (Breeze Dark), colors, fonts
- **config/plasma/kwinrc** - KWin window manager settings:
  - 6 named virtual desktops (Main, Firefox, Emacs, Thunderbird, Telegram, Digikam)
  - Tiling configuration with 4px padding
  - Night Color enabled (Dresden coordinates)
  - Window effects (wobbly windows, translucency)
- **config/plasma/kwinrulesrc** - Window rules for automatic app→desktop assignments:
  - Firefox → Desktop 2 (maximized)
  - Emacs → Desktop 3 (maximized)
  - Thunderbird → Desktop 4 (maximized)
  - Telegram → Desktop 5 (maximized)
  - Digikam → Desktop 6
  - Kitty → Desktop 1
- **config/plasma/kglobalshortcutsrc** - All custom keyboard shortcuts (292 lines)
- **config/plasma/plasmashellrc** - Panel appearance (floating, opacity)

**Not tracked** (too dynamic or machine-specific):
- Panel widget layout (`plasma-org.kde.plasma.desktop-appletsrc`) - reconfigure manually
- Monitor configuration (`kwinoutputconfig.json`) - hardware-specific
- Notifications, locale (using defaults)

#### Plasma Widgets
- **local/share/plasma/plasmoids/com.github.victorballester7.titlebingwallpaper/** - Git submodule
  - Bing Picture of the Day widget
  - Shows daily wallpaper title and information
  - Repository: https://github.com/victorballester7/title-bing-wallpaper
  - Automatically symlinked by setup script

#### SDDM Display Manager
- **sddm/kde_settings.conf** - SDDM configuration (Breeze theme, fonts)
- **sddm/install_sddm.sh** - Installation script (requires sudo)
- **sddm/README.md** - Documentation

**To install SDDM config:**
```bash
cd ~/dev/dotfiles/sddm
./install_sddm.sh
```

#### System Configuration References
- **system/** - Reference copies of system-level configs (require sudo)
  - **modprobe.d/nvidia.conf** - NVIDIA kernel module configuration for Wayland
  - Not automatically installed - see `system/README.md` for manual installation

### Utilities
- **apps/bin/** - Custom scripts and utilities

### Sort_pictures Service
- **sort_pictures/** - Git submodule containing Rust-based photo organization service
- Automatically organizes photos by date and GPS location
- Systemd user service runs in background
- Config: `~/.config/sort_pictures/config.toml` (symlinked from submodule)
- Service: `~/.config/systemd/user/sort_pictures.service` (symlinked from submodule)

**To build and install:**
```bash
cd ~/dev/dotfiles/sort_pictures
./install.sh
systemctl --user enable --now sort_pictures.service
```

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

## Audio System

Using **PipeWire** as the modern audio server with PulseAudio compatibility:
- Lower latency than PulseAudio
- Better Bluetooth support (aptX, LDAC, AAC codecs)
- JACK compatibility for pro audio
- Excellent Wayland integration
- WirePlumber session manager handles Bluetooth automatically

**Packages:**
- `pipewire` - Core multimedia server
- `pipewire-pulse` - PulseAudio compatibility layer
- `pipewire-alsa` - ALSA support
- `pipewire-jack` - JACK support
- `wireplumber` - Session manager (includes Bluetooth)
- `bluez` + `bluez-utils` - Bluetooth stack

## Input Method

Fcitx5 is configured as the default input method framework:
- GLFW_IM_MODULE=fcitx
- GTK_IM_MODULE=fcitx
- QT_IM_MODULE=fcitx
- XMODIFIERS=@im=fcitx

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
├── .gitmodules            # Git submodules config
├── emacs.d/               # Emacs init
├── config/
│   ├── emacs/            # Main Emacs config
│   ├── kitty/            # Terminal config
│   ├── plasma/           # KDE Plasma configs
│   │   ├── kdeglobals
│   │   ├── kwinrc
│   │   ├── kwinrulesrc
│   │   ├── kglobalshortcutsrc
│   │   └── plasmashellrc
│   ├── pulse/            # Audio config
│   └── wallpaper.JPG     # Desktop wallpaper
├── gnupg/
│   ├── gpg.conf          # GPG configuration
│   └── gpg-agent.conf    # GPG agent config
├── apps/
│   └── bin/              # Custom scripts
├── sort_pictures/         # Git submodule - photo organizer
│   ├── systemd/
│   │   ├── sort_pictures.service
│   │   └── config.toml
│   ├── src/              # Rust source code
│   └── install.sh        # Build & install script
├── local/share/           # Local user data
│   └── plasma/plasmoids/
│       └── com.github.victorballester7.titlebingwallpaper/  # Git submodule
├── sddm/                  # SDDM display manager config
│   ├── kde_settings.conf
│   ├── install_sddm.sh
│   └── README.md
├── system/                # System config references (require sudo)
│   ├── modprobe.d/
│   │   └── nvidia.conf   # NVIDIA Wayland support
│   └── README.md
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

To update submodules (sort_pictures):
```bash
git submodule update --remote
cd sort_pictures
./install.sh  # Rebuild if needed
```

To restore configs on a new system:
1. Clone this repository: `git clone <repo-url> ~/dev/dotfiles`
2. Initialize submodules: `git submodule update --init --recursive`
3. Run `./setup_symlinks.sh`
4. Build sort_pictures: `cd sort_pictures && ./install.sh`
5. Install required packages (Emacs, Kitty, Starship, Fcitx5, etc.)
6. Restart shell or source `~/.bashrc`

## License

See LICENSE file for details.
