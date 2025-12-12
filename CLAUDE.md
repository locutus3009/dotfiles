# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **personal dotfiles repository** for Arch Linux with **KDE Plasma 6** as the primary desktop. The repository uses **GNU Stow** for symlink management, organizing configs into modular packages.

**Target System:**
- Arch Linux (rolling release)
- **KDE Plasma 6** (primary desktop)
- PipeWire audio (not PulseAudio)
- Fcitx5 input method
- SDDM display manager
- Material You dynamic theming via `kde-material-you-colors` + `matugen`

## Key Commands

### Initial Setup on New System
```bash
# Clone and initialize
cd ~/dev
git clone <repo-url> dotfiles
cd dotfiles
git submodule update --init --recursive

# Remove existing config files that would conflict with stow
rm ~/.bashrc ~/.gdbinit ~/.asound.conf ~/bash-preexec.sh
rm -rf ~/.config/emacs ~/.config/kitty ~/.config/pulse
rm -rf ~/.config/matugen ~/.config/kde-material-you-colors

# Run install script (handles everything)
./install.sh

# Enable kde-material-you-colors autostart
kde-material-you-colors --autostart

# Reboot
reboot
```

**install.sh automatically handles:**
- Package installation (only missing packages)
- NVIDIA drivers and modprobe config (with prompts)
- SDDM configuration and service
- Bluetooth service enablement
- **Building Rust binaries** (sort_pictures, sportmodel) into `stow/apps/apps/bin/`
- GNU Stow dotfiles setup (requires binaries to be built first)
- Systemd service enablement for sort_pictures and sportmodel

### Updating Configurations
```bash
# Edit config files in stow packages - changes are live via symlinks
# Commit when ready
git add .
git commit -m "Description"
git push

# Re-stow after adding new files to packages
./stow.sh

# Update submodules
git submodule update --remote
```

### Plasma Shell Management
```bash
# Restart plasmashell to reload widget changes
killall plasmashell && plasmashell &

# Reload KWin configuration
qdbus6 org.kde.KWin /KWin reconfigure
```

## Architecture

### GNU Stow Package Structure

The repository uses GNU Stow with packages in the `stow/` directory:

| Package | Contents | Target |
|---------|----------|--------|
| `bash` | `.bashrc`, `.gdbinit`, `.asound.conf`, `bash-preexec.sh` | `$HOME` |
| `emacs` | `.emacs.d/`, `.config/emacs/` | `$HOME` |
| `gnupg` | `.gnupg/gpg-agent.conf`, `.gnupg/gpg.conf` | `$HOME` |
| `kitty` | `.config/kitty/` | `$HOME` |
| `pulse` | `.config/pulse/` | `$HOME` |
| `plasma` | `.config/{kdeglobals,kwinrc,kwinrulesrc,kglobalshortcutsrc,plasmashellrc}` | `$HOME` |
| `apps` | `apps/bin/` (binaries built locally, not in git) | `$HOME` |
| `sort-pictures` | systemd service + config.toml | `$HOME` |
| `sportmodel-service` | systemd service for sportmodel web server | `$HOME` |
| `plasma-widgets` | Window Title + Bing Wallpaper plasmoids | `$HOME` |
| `kde-material-you-colors` | color generation config + hook | `$HOME` |
| `matugen` | template config for Emacs/GTK | `$HOME` |

**Stow commands:**
```bash
./stow.sh                    # Stow all packages (requires binaries built first!)
./stow.sh bash emacs         # Stow specific packages
./stow.sh --unstow plasma    # Remove symlinks for a package
./stow.sh --simulate         # Preview changes without applying
./stow.sh --adopt            # Adopt existing files into stow
```

**Important:** `stow.sh` will fail if binaries are missing from `stow/apps/apps/bin/`. Run `./install.sh` first on a fresh clone.

### Git Submodules

1. **sort_pictures** (`git@github.com:locutus3009/sort_pictures.git`)
   - Rust-based photo organizer with GPS support
   - Runs as systemd user service
   - Config symlinked via `sort-pictures` stow package

2. **sportmodel** (`git@github.com:locutus3009/sportmodel.git`)
   - Strength training analytics with Gaussian Process regression
   - Web server on port 8473 (http://localhost:8473)
   - Watches Excel file for live reload
   - Service config via `sportmodel-service` stow package

3. **title-bing-wallpaper** (`https://github.com/victorballester7/title-bing-wallpaper.git`)
   - Path: `stow/plasma-widgets/.local/share/plasma/plasmoids/com.github.victorballester7.titlebingwallpaper`
   - KDE Plasma widget for Bing Picture of the Day

**Additional Plasma Widgets (not submodules):**
- `org.kde.windowtitle` - Window title plasmoid (in `stow/plasma-widgets/`)

## Material You Theming

The system automatically generates Material You colors from the desktop wallpaper:

```
┌─────────────────────────────────────────────────────────────────┐
│                   MATERIAL YOU COLOR FLOW                        │
├─────────────────────────────────────────────────────────────────┤
│ Plasma Wallpaper Change (Bing POTD, manual, etc.)               │
│         │                                                        │
│         ▼                                                        │
│ kde-material-you-colors (daemon, monitors via D-Bus)            │
│         │                                                        │
│         ├──► Updates KDE color schemes (Plasma/Qt apps)         │
│         │                                                        │
│         ▼                                                        │
│ on_change_hook → matugen-hook.sh                                │
│         │                                                        │
│         ▼                                                        │
│ matugen color hex <seed>                                        │
│         │                                                        │
│         ▼                                                        │
│ Generates templates:                                             │
│ - ~/.config/emacs/generated.el (Emacs theme)                    │
│ - ~/.config/gtk-3.0/gtk.css                                     │
│ - ~/.config/gtk-4.0/gtk.css                                     │
└─────────────────────────────────────────────────────────────────┘
```

### Configuration Files

- `stow/kde-material-you-colors/.config/kde-material-you-colors/config.conf`
- `stow/kde-material-you-colors/.config/kde-material-you-colors/matugen-hook.sh`
- `stow/matugen/.config/matugen/config.toml`
- `stow/matugen/.config/matugen/templates/`

### Manual Color Update

```bash
# Extract seed color and run matugen manually
color=$(jq -r '.seed.color' /tmp/kde-material-you-colors-$(whoami).json)
matugen color hex "$color" --mode dark

# Or restart kde-material-you-colors to re-detect wallpaper
pkill kde-material-you-colors
kde-material-you-colors &
```

## Important Configuration Details

### Audio: PipeWire (Not PulseAudio)
The system uses PipeWire with PulseAudio compatibility layer:
- `pipewire-pulse` provides `/run/user/$UID/pulse/native` socket
- `pactl info` shows: "Server Name: PulseAudio (on PipeWire)"
- WirePlumber manages Bluetooth audio automatically

### GPG Agent as SSH Agent
`.bashrc` configures GPG agent to handle SSH:
```bash
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
```

### Emacs Daemon Mode
Emacs runs as a daemon with wrapper aliases (defined in `.bashrc`):
- `cemacscli` - Terminal emacsclient
- `emacscli` - GUI emacsclient
- `cmagit` / `magit` - Magit in terminal/GUI

### Desktop Layout
KWin is configured with 6 named virtual desktops and window rules:
- Desktop 1 (Main) - Kitty
- Desktop 2 (Firefox) - Firefox (maximized)
- Desktop 3 (Emacs) - Emacs (maximized)
- Desktop 4 (Thunderbird) - Thunderbird (maximized)
- Desktop 5 (Telegram) - Telegram (maximized)
- Desktop 6 (Digikam) - Digikam

## Rust Binaries (sort_pictures & sportmodel)

**Binaries are NOT stored in git.** They must be built locally before running stow.

The `apps` stow package expects binaries at:
- `stow/apps/apps/bin/sort_pictures`
- `stow/apps/apps/bin/sportmodel`

### Build via install.sh (recommended)
`./install.sh` prompts to build both binaries before running stow.

### Manual build
```bash
# sort_pictures
cd sort_pictures && cargo build --release
cp target/release/sort_pictures ../stow/apps/apps/bin/

# sportmodel
cd ../sportmodel && cargo build --release
cp target/release/sportmodel ../stow/apps/apps/bin/

# Then run stow
cd .. && ./stow.sh
```

### After submodule updates
```bash
git submodule update --remote
# Rebuild binaries
cd sort_pictures && cargo build --release
cp target/release/sort_pictures ../stow/apps/apps/bin/
cd ../sportmodel && cargo build --release
cp target/release/sportmodel ../stow/apps/apps/bin/
# Restart services
systemctl --user restart sort_pictures.service sportmodel.service
```

**sportmodel web server:** http://localhost:8473

**Do NOT run** `sort_pictures/install.sh` — it conflicts with stow symlinks.

## Working with This Repository

### Adding New Configurations

1. Create a new stow package directory: `mkdir -p stow/appname/.config/appname/`
2. Add config files to the package
3. Add the package name to `stow.sh` ALL_PACKAGES array
4. Run `./stow.sh appname`
5. Document in this file

### Modifying Plasma Configs
**Caution:** Plasma configs are symlinked. Editing them changes both:
- The file in the stow package (tracked by git)
- The active system configuration

Plasma may also write to these files when settings change via GUI. Check `git status` frequently.

### Package Management
`install.sh` uses `yay` (AUR helper) with `--needed` flag. Required packages include:
- `stow` - GNU Stow for symlink management
- `kde-material-you-colors` - Automatic color generation
- `matugen-bin` - Template-based theme generator

## Common Pitfalls

1. **Running stow with existing files**
   - Stow will fail if target files exist
   - Remove existing files first, or use `./stow.sh --adopt`

2. **Running stow.sh without building binaries first**
   - `stow.sh` will fail if `stow/apps/apps/bin/sort_pictures` or `sportmodel` are missing
   - Run `./install.sh` first, or build manually (see "Rust Binaries" section)

3. **Forgetting to rebuild after submodule updates**
   - After `git submodule update --remote`: rebuild binaries and restart services
   - See "After submodule updates" in "Rust Binaries" section

4. **Editing Plasma configs via GUI**
   - Changes write to symlinked files (shows in `git status`)
   - Review and commit intentional changes
   - Use `git checkout` to revert unintended changes

5. **Assuming PulseAudio is active**
   - System uses PipeWire with PA compatibility
   - Don't install `pulseaudio` package

6. **kde-material-you-colors not running**
   - Run `kde-material-you-colors --autostart` to enable autostart
   - Or start manually: `kde-material-you-colors &`

## Legacy: dots-hyprland Reference

The repository `/home/locutus/dev/dots-hyprland` contains an archived Hyprland setup (fork of end-4/dots-hyprland). It is **not active** but kept for reference:
- Hyprland compositor configuration
- Quickshell bar and widgets
- The original Material You theming scripts

The current setup uses a decoupled approach that works with Plasma's native wallpaper handling.

## File Structure

```
dotfiles/
├── stow/                    # GNU Stow packages
│   ├── bash/
│   ├── emacs/
│   ├── gnupg/
│   ├── kitty/
│   ├── pulse/
│   ├── plasma/
│   ├── apps/
│   ├── sort-pictures/
│   ├── sportmodel-service/
│   ├── plasma-widgets/
│   ├── kde-material-you-colors/
│   └── matugen/
├── sort_pictures/           # Git submodule
├── sportmodel/              # Git submodule
├── legacy/                  # Archived configs (AwesomeWM, X11)
├── system/                  # System-level configs (not symlinked)
├── sddm/                    # SDDM display manager config
├── install.sh               # Package installation script
├── stow.sh                  # GNU Stow wrapper
└── CLAUDE.md                # This file
```

## Repository Location

**This dotfiles repo:** `/hdd/locutus/dev/dotfiles`
- Symlink at `~/dev/dotfiles`
- Personal data on `/hdd/locutus/` (separate partition)
