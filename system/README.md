# System Configuration References

This directory holds **reference copies** of system-level configuration files
that require root/sudo privileges to install (i.e. files that live under `/etc`
and are therefore not managed by GNU Stow).

## Contents

_None currently._

The machine runs on AMD graphics (`amdgpu`), which needs no special modprobe
configuration — early KMS is handled by `MODULES=(amdgpu)` in
`/etc/mkinitcpio.conf`, and CPU microcode is bundled automatically by the
`microcode` mkinitcpio hook (`amd-ucode`).

## Notes

- Files here are **not** automatically installed by `stow.sh` — they require
  manual installation with sudo.
- Always review system config files before copying them into `/etc/`.
- Keep these updated when you make system-level changes.
