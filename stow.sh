#!/bin/bash
# stow.sh - GNU Stow-based symlink management for dotfiles
# Usage: ./stow.sh [--unstow] [--adopt] [--simulate] [package...]

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STOW_DIR="$DOTFILES_DIR/stow"

# All available packages
ALL_PACKAGES=(
    bash
    emacs
    gnupg
    kitty
    pulse
    plasma
    apps
    sort-pictures
    sportmodel-service
    plasma-widgets
    kde-material-you-colors
    matugen
)

# Parse arguments
UNSTOW=false
ADOPT=false
SIMULATE=false
PACKAGES=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --unstow|-D)
            UNSTOW=true
            shift
            ;;
        --adopt)
            ADOPT=true
            shift
            ;;
        --simulate|-n)
            SIMULATE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--unstow] [--adopt] [--simulate] [package...]"
            echo ""
            echo "Options:"
            echo "  --unstow, -D    Remove symlinks instead of creating them"
            echo "  --adopt         Adopt existing files into stow (use with caution)"
            echo "  --simulate, -n  Show what would be done without making changes"
            echo "  --help, -h      Show this help message"
            echo ""
            echo "Available packages:"
            for pkg in "${ALL_PACKAGES[@]}"; do
                echo "  $pkg"
            done
            echo ""
            echo "If no packages are specified, all packages are processed."
            echo ""
            echo "First-time setup:"
            echo "  If you have existing configs, first remove old symlinks:"
            echo "    rm ~/.bashrc ~/.gdbinit ~/.asound.conf ~/bash-preexec.sh"
            echo "  Then run: ./stow.sh"
            exit 0
            ;;
        *)
            PACKAGES+=("$1")
            shift
            ;;
    esac
done

# If no packages specified, use all
if [[ ${#PACKAGES[@]} -eq 0 ]]; then
    PACKAGES=("${ALL_PACKAGES[@]}")
fi

# Build stow flags
STOW_FLAGS=""
if $UNSTOW; then
    ACTION="Unstowing"
    STOW_FLAGS="-D"
else
    ACTION="Stowing"
    STOW_FLAGS="--restow"
fi

if $ADOPT; then
    STOW_FLAGS="$STOW_FLAGS --adopt"
fi

if $SIMULATE; then
    STOW_FLAGS="$STOW_FLAGS --simulate"
    echo "[SIMULATION MODE - no changes will be made]"
    echo ""
fi

echo "$ACTION packages to $HOME..."
echo ""

for pkg in "${PACKAGES[@]}"; do
    if [[ -d "$STOW_DIR/$pkg" ]]; then
        echo "  $pkg"
        stow -d "$STOW_DIR" -t "$HOME" $STOW_FLAGS "$pkg"
    else
        echo "  [skip] $pkg - not found in $STOW_DIR"
    fi
done

echo ""
echo "Done."
