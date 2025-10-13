# System Configuration References

This directory contains **reference copies** of system-level configuration files that require root/sudo privileges to install. These are provided for documentation and reference purposes.

## Contents

### modprobe.d/nvidia.conf
NVIDIA kernel module configuration for Wayland support.

**Content:**
```
options nvidia_drm modeset=1 fbdev=1
```

**To install:**
```bash
sudo cp system/modprobe.d/nvidia.conf /etc/modprobe.d/nvidia.conf
sudo chmod 644 /etc/modprobe.d/nvidia.conf
# Rebuild initramfs
sudo mkinitcpio -P
# Reboot for changes to take effect
```

**Purpose:**
- `modeset=1` - Enables kernel mode-setting for NVIDIA DRM
- `fbdev=1` - Enables framebuffer device support
- Required for NVIDIA GPU to work properly with Wayland

## Notes

- These files are **not automatically installed** by `setup_symlinks.sh`
- They require manual installation with sudo privileges
- Always review system config files before copying to `/etc/`
- Keep these updated when you make system-level changes
