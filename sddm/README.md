# SDDM Configuration

SDDM (Simple Desktop Display Manager) configuration for KDE Plasma.

## Contents

- **kde_settings.conf** - SDDM display manager configuration
  - Theme: Breeze
  - Cursor: breeze_cursors
  - Font: Noto Sans 10pt
  - Shutdown/reboot commands configured

## Installation

SDDM configuration files require root privileges to install:

```bash
cd ~/dev/dotfiles/sddm
./install_sddm.sh
```

This will copy `kde_settings.conf` to `/etc/sddm.conf.d/` with proper permissions.

**Note:** Changes take effect on next login/reboot.

## Manual Installation

If you prefer to install manually:

```bash
sudo cp kde_settings.conf /etc/sddm.conf.d/
sudo chmod 644 /etc/sddm.conf.d/kde_settings.conf
```

## Customization

Edit `kde_settings.conf` to customize:
- Display manager theme
- Cursor theme
- Font settings
- Autologin settings (currently disabled)

After editing, run `./install_sddm.sh` again to apply changes.
