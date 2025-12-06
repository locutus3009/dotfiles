# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **personal dotfiles repository** for Arch Linux with a **hybrid desktop setup**: Hyprland as the primary compositor with KDE Plasma 6 as fallback. The repository uses a symlink-based approach where configuration files remain in the repo and are symlinked to their expected locations in `$HOME`.

**Target System:**
- Arch Linux (rolling release)
- **Hyprland** (primary compositor) — via separate `dots-hyprland` repository
- **KDE Plasma 6** (fallback compositor) — configs in this repo
- PipeWire audio (not PulseAudio)
- Fcitx5 input method
- SDDM display manager (supports both Hyprland and Plasma sessions)

## Key Commands

### Initial Setup on New System
```bash
# Clone and initialize
cd ~/dev
git clone <repo-url> dotfiles
cd dotfiles
git submodule update --init --recursive

# Install packages (requires yay AUR helper)
./install.sh

# Create symlinks
./setup_symlinks.sh

# Build and enable sort_pictures service
cd sort_pictures && ./install.sh
systemctl --user enable --now sort_pictures.service

# Install SDDM configuration (requires sudo)
cd sddm && ./install_sddm.sh

# Enable system services
sudo systemctl enable sddm bluetooth
systemctl --user enable --now syncthing.service
```

### Updating Configurations
```bash
# Edit config files in dotfiles repo - changes are live via symlinks
# Commit when ready
git add .
git commit -m "Description"
git push

# Update submodules
git submodule update --remote
cd sort_pictures && ./install.sh  # Rebuild if needed
```

### Plasma Shell Management (Fallback Desktop)
```bash
# Restart plasmashell to reload widget changes
killall plasmashell && plasmashell &

# Reload KWin configuration
kwin_wayland --replace &
```

### Hyprland Management (Primary Desktop)
```bash
# Reload Hyprland configuration
hyprctl reload

# Check Hyprland logs
journalctl --user -u hyprland.service -f

# Hyprland configs are at ~/.config/hypr/ (managed by dots-hyprland)
```

## Architecture

### Symlink Strategy
The repository does NOT modify files in place. Instead:
1. Configuration files live in the dotfiles repository
2. `setup_symlinks.sh` creates symlinks from `$HOME` to the repo
3. Changes to tracked configs immediately affect the system AND git status

**Critical:** Symlinks use **absolute paths** based on `$(pwd)`, so the script must be run from the repo root.

### Git Submodules
Two active submodules plus one orphaned entry:

1. **sort_pictures** (`git@github.com:locutus3009/sort_pictures.git`)
   - Rust-based photo organizer with GPS support
   - Runs as systemd user service
   - Config at `sort_pictures/systemd/config.toml` (symlinked to `~/.config/sort_pictures/`)
   - Service file symlinked to `~/.config/systemd/user/`

2. **title-bing-wallpaper** (`https://github.com/victorballester7/title-bing-wallpaper.git`)
   - Path: `local/share/plasma/plasmoids/com.github.victorballester7.titlebingwallpaper/`
   - KDE Plasma widget for Bing Picture of the Day
   - Symlinked to `~/.local/share/plasma/plasmoids/`

3. **ranger_devicons** ⚠️ ORPHANED
   - Listed in `.gitmodules` at `config/ranger/plugins/ranger_devicons`
   - Directory does not exist (path never created or was removed)
   - Causes `git submodule status` to fail
   - Kept for potential future use; ignore the warning

### Selective Plasma Configuration Tracking

**Tracked configs in repo** (stable, portable):
- `config/plasma/kdeglobals` - Theme, colors, fonts (Breeze Dark reference)
- `config/plasma/kwinrc` - Window manager settings (6 named desktops, tiling, effects)
- `config/plasma/kwinrulesrc` - Window rules (app→desktop assignments)
- `config/plasma/kglobalshortcutsrc` - Keyboard shortcuts
- `config/plasma/plasmashellrc` - Panel appearance

**Currently symlinked** (active on system):
- `kwinrc`, `kwinrulesrc`, `kglobalshortcutsrc`, `plasmashellrc` → symlinked to repo

**NOT symlinked** (managed separately):
- `kdeglobals` — Currently using **dots-hyprland's Material You theme** instead of repo version
  - `~/.config/kdeglobals` is a regular file, not a symlink
  - To restore: `ln -sf /hdd/locutus/dev/dotfiles/config/plasma/kdeglobals ~/.config/kdeglobals`

**NOT tracked** (dynamic or machine-specific):
- `plasma-org.kde.plasma.desktop-appletsrc` - Panel widget layout (changes often)
- `kwinoutputconfig.json` - Monitor configuration (hardware-specific)

**Rationale:** Panel widgets change frequently with every UI tweak. Monitor configs contain hardware-specific IDs. Users must reconfigure these manually on new systems.

### System-Level Configurations

**system/** directory contains reference copies (NOT symlinked):
- `system/modprobe.d/nvidia.conf` - NVIDIA DRM modeset for Wayland
- Requires manual `sudo cp` to `/etc/` - see `system/README.md`

**sddm/** directory has install script:
- `sddm/kde_settings.conf` - SDDM display manager config
- `sddm/install_sddm.sh` - Automated sudo install script

### Legacy Configurations

**legacy/** contains archived AwesomeWM and X11 configs:
- Entire AwesomeWM setup (Lua configs, themes, widgets)
- X11-specific files (xprofile, xinitrc, Xdefaults, xbindkeysrc)
- Old application configs (ranger, picom, mpd, terminator)

These are preserved for reference but not installed by `setup_symlinks.sh`.

### Hyprland Integration (Primary Desktop)

The primary desktop environment is **Hyprland**, managed by a separate repository:

**Repository:** `/home/locutus/dev/dots-hyprland`
- Fork of `end-4/dots-hyprland` ("illogical-impulse")
- Independent installation via `./setup install`
- NOT a submodule of this dotfiles repo

**What dots-hyprland provides:**
- Hyprland compositor configuration (`~/.config/hypr/`)
- Quickshell bar and widgets
- Fuzzel application launcher
- Foot terminal (alternative to Kitty)
- Hyprlock screen locker
- Material You dynamic theming (kde-material-you-colors, matugen)
- Custom kdeglobals with Material You theme

**Relationship to this repo:**
- This dotfiles repo provides: shell (bashrc), Emacs, GPG, sort_pictures, Plasma fallback configs
- dots-hyprland provides: Hyprland configs, Material You theming, quickshell widgets
- **Shared/conflicting configs:**
  - `kitty` — This repo's config enhanced with dots-hyprland scripts (scroll_mark.py, search.py)
  - `kdeglobals` — dots-hyprland's Material You theme active (not symlinked from this repo)
  - `starship.toml` — Both repos have versions; dots-hyprland's is active

**Setup order for new system:**
1. Clone and set up this dotfiles repo first (shell, Emacs, base configs)
2. Clone and run dots-hyprland `./setup install` second (overwrites some configs)
3. Re-run `setup_symlinks.sh` to restore specific symlinks if needed

**Switching between Hyprland and Plasma:**
- SDDM login screen offers both sessions
- Hyprland: Primary daily use
- Plasma: Fallback for KDE-specific tasks or troubleshooting

## Important Configuration Details

### Audio: PipeWire (Not PulseAudio)
The system uses PipeWire with PulseAudio compatibility layer:
- `pipewire-pulse` provides `/run/user/$UID/pulse/native` socket
- `pactl info` shows: "Server Name: PulseAudio (on PipeWire 1.4.8)"
- WirePlumber manages Bluetooth audio automatically
- `config/pulse/` directory still exists for compatibility configs

**When editing audio configs:** PipeWire reads PulseAudio configs but don't assume PulseAudio is running.

### GPG Agent as SSH Agent
`bashrc.dot.sh` configures GPG agent to handle SSH:
```bash
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
```
SSH keys are managed through GPG, not ssh-agent.

### Emacs Daemon Mode
Emacs runs as a daemon with wrapper aliases (defined in `bashrc.dot.sh`):
- `cemacscli` - Terminal emacsclient
- `emacscli` - GUI emacsclient
- `cmagit` / `magit` - Magit in terminal/GUI

The daemon was previously auto-launched by the archived `legacy/xprofile.dot`. Modern setup relies on user starting daemon manually or through desktop autostart.

### Desktop Layout (Plasma Fallback)
KWin is configured with 6 named virtual desktops and window rules:
- Desktop 1 (Main) - Kitty
- Desktop 2 (Firefox) - Firefox (maximized)
- Desktop 3 (Emacs) - Emacs (maximized)
- Desktop 4 (Thunderbird) - Thunderbird (maximized)
- Desktop 5 (Telegram) - Telegram (maximized)
- Desktop 6 (Digikam) - Digikam

Window rules auto-assign and maximize applications. Defined in `config/plasma/kwinrulesrc`.

**Note:** Hyprland has its own workspace configuration in `~/.config/hypr/` managed by dots-hyprland.

## Working with This Repository

### Adding New Configurations
1. Add the config file to appropriate directory (e.g., `config/appname/`)
2. Add symlink command to `setup_symlinks.sh`
3. Document in README.md under "Active Configurations"
4. Test by running `setup_symlinks.sh`

### Modifying Plasma Configs
**Caution:** Plasma configs are symlinked. Editing them changes both:
- The file in the repo (tracked by git)
- The active system configuration

Plasma may also write to these files when settings change via GUI. Check `git status` frequently.

### Package Management
`install.sh` uses `yay` (AUR helper) with `--needed` flag:
- Only installs missing packages
- Prompts for NVIDIA drivers (yes/no)
- Enables bluetooth.service via sudo

When adding packages, maintain categorical organization and comments.

### Submodule Updates
```bash
# Update all submodules to latest
git submodule update --remote --merge

# Update specific submodule
cd sort_pictures
git pull origin master
cd ..
git add sort_pictures
git commit -m "Update sort_pictures submodule"
```

## Common Pitfalls

1. **Running setup_symlinks.sh from wrong directory**
   - Script uses `$(pwd)` for absolute paths
   - Must run from repo root: `/hdd/locutus/dev/dotfiles`

2. **Forgetting to rebuild sort_pictures**
   - After submodule update: `cd sort_pictures && ./install.sh`
   - Service must be restarted: `systemctl --user restart sort_pictures.service`

3. **Editing Plasma configs via GUI**
   - Changes write to symlinked files (shows in `git status`)
   - Review and commit intentional changes
   - Use `git checkout` to revert unintended changes

4. **Assuming PulseAudio is active**
   - System uses PipeWire with PA compatibility
   - Don't install `pulseaudio` package - conflicts with `pipewire-pulse`

5. **Tracking machine-specific configs**
   - Don't track monitor configs or panel widget layouts
   - These contain UUIDs and screen-specific settings
   - Document manual reconfiguration steps instead

6. **Running dots-hyprland setup overwrites configs**
   - `dots-hyprland ./setup install` may replace symlinks with regular files
   - Specifically: kdeglobals, kitty config, starship.toml
   - Re-run `setup_symlinks.sh` afterward to restore needed symlinks
   - Current state: kdeglobals intentionally left as dots-hyprland version

7. **Orphaned ranger_devicons submodule**
   - `git submodule status` will fail due to orphaned `.gitmodules` entry
   - This is known and intentional; the submodule path was never created
   - Use `git submodule update --init sort_pictures` to update only active submodules

## File Naming Conventions

- `.dot` suffix → Target has `.` prefix (e.g., `bashrc.dot.sh` → `~/.bashrc`)
- `config/` directory → Maps to `~/.config/`
- No suffix transformation needed for `config/` subdirs

## Repository Locations

**This dotfiles repo:** `/hdd/locutus/dev/dotfiles`
- Symlink at `~/dev/dotfiles`
- Personal data on `/hdd/locutus/` (separate partition)
- Provides: shell, Emacs, GPG, sort_pictures, Plasma fallback configs

**Hyprland dotfiles (separate repo):** `/home/locutus/dev/dots-hyprland`
- Fork of end-4/dots-hyprland
- Provides: Hyprland, quickshell, Material You theming
- Independent installation, not a submodule
