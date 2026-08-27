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

# Run install script (handles everything)
./install.sh

# Reboot
reboot
```

**install.sh automatically handles:**
- Package installation (only missing packages)
- SDDM configuration and service
- Bluetooth service enablement
- Tree-sitter grammars for the Emacs `*-ts-mode` major modes
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
| `plasma` | `.config/{kwinrc,kwinrulesrc,kglobalshortcutsrc}` | `$HOME` |
| `apps` | `apps/bin/` (binaries built locally, not in git) | `$HOME` |
| `sort-pictures` | systemd service + config.toml | `$HOME` |
| `sportmodel-service` | systemd service for sportmodel web server | `$HOME` |
| `plasma-widgets` | Window Title + Bing Wallpaper plasmoids | `$HOME` |
| `mpd` | `.config/mpd/mpd.conf` (local-only MPD, PipeWire output) | `$HOME` |
| `mpd-mpris` | systemd `--user` drop-in for the MPRIS bridge | `$HOME` |
| `ncmpcpp` | `.config/ncmpcpp/config` (TUI client) | `$HOME` |
| `picard` | `.config/MusicBrainz/Picard.ini` (MusicBrainz Picard tagger) | `$HOME` |

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

## Important Configuration Details

### Audio: PipeWire (Not PulseAudio)
The system uses PipeWire with PulseAudio compatibility layer:
- `pipewire-pulse` provides `/run/user/$UID/pulse/native` socket
- `pactl info` shows: "Server Name: PulseAudio (on PipeWire)"
- WirePlumber manages Bluetooth audio automatically

### MPD (Music Player Daemon)

MPD runs as a **per-user** systemd service (`systemctl --user`), not the system
`mpd` unit — so it uses the session's PipeWire and never needs the system `mpd`
user's permissions on `/hdd`.

- **Config:** `stow/mpd/.config/mpd/mpd.conf` (in git). Local only
  (`bind_to_address 127.0.0.1`), native `pipewire` output, `m3u`+`pls` playlist
  plugins enabled for radio streams.
- **Library:** `/hdd/locutus/Music` (via the `~/Music` symlink), synced by
  Syncthing. `auto_update "yes"` picks up new tracks via inotify.
- **Playlists:** `/hdd/locutus/Music/playlists/` — kept **inside** the synced
  library so saved playlists and radio stations travel between machines.
- **Runtime state** (`database`, `state`, `sticker.sql`) lives in
  `~/.local/share/mpd/` — deliberately **outside** git and outside the synced
  music tree, so no generated files are committed or replicated.
- **Clients:** `ncmpcpp` (TUI, configured in `stow/ncmpcpp`), `mpc`
  (CLI/scripting), and Emacs's built-in `mpc.el`
  (`stow/emacs/.config/emacs/music.el`, `M-x mpc` / `C-c m`). A silent `fifo`
  output in `mpd.conf` feeds the ncmpcpp visualizer (`/tmp/mpd.fifo`) — it plays
  alongside PipeWire, inaudibly.
- **Plasma control:** `mpd-mpris` bridges MPD to MPRIS so the Plasma Media
  Player widget and `playerctl` can drive playback. Its `--user` unit ships with
  the package; `stow/mpd-mpris/` adds a drop-in (`After=mpd.service`,
  `MPD_HOST=127.0.0.1`).

```bash
# First run / after large library changes: build the database
mpc update && mpc stats

# Service status / logs
systemctl --user status mpd mpd-mpris
journalctl --user -u mpd
```

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

Only the genuinely hand-authored, low-churn files are stowed: `kwinrc` (virtual
desktops, compositing), `kwinrulesrc` (window rules), `kglobalshortcutsrc`
(shortcuts). `kdeglobals` and `plasmashellrc` are **deliberately not tracked** —
KConfig interleaves real settings with volatile UI state (file-dialog view,
panel/plasmoid geometry), so tracking them produced constant git noise for no
benefit. They live as normal KDE-owned files in `~/.config`.

### Package Management
`install.sh` uses `yay` (AUR helper) with `--needed` flag. Required packages include:
- `stow` - GNU Stow for symlink management
- `ripgrep`, `fd`, `clang` - shelled out to by the Emacs config (search,
  project indexing, clangd/clang-format)

**Tree-sitter grammars.** `PACKAGES_TREESITTER` installs the grammars behind
the Emacs `*-ts-mode` modes (C, Rust, Python, Bash, Lua) from the official
repos. Each mode is enabled only when its grammar is present, so a partial
install just falls back to the classic modes.

Two grammars are handled differently:
- **C++** is not in the official repos, so `install.sh` never installs it and
  never calls `yay` for it - it prints a manual step instead, since AUR is not
  reachable everywhere (a work machine, for one). Either `yay -S
  tree-sitter-cpp`, or the AUR-free route: `M-x
  treesit-install-language-grammar RET cpp RET` builds it into
  `~/.emacs.d/tree-sitter/` without root.
- **Markdown** is deliberately not installed: `markdown-ts-mode` is much
  thinner than the `markdown-mode` package the config uses, so the config
  stays on `markdown-mode` and the grammar would go unused.

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
│   ├── mpd/
│   ├── mpd-mpris/
│   ├── ncmpcpp/
│   └── picard/
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
