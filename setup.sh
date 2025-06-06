#!/bin/bash
# setup.sh - Install Fiwix build dependencies and create the initial disk image.
# Works on Debian 12 and Ubuntu 24.04.

set -euo pipefail

# Packages needed for building the kernel
BUILD_PKGS=(
    gcc-multilib
    libc6-dev-i386
)

# Bochs emulator and helpers
BOCHS_PKGS=(
    bochs
    bochs-sdl
    bochs-wx
    bochs-x
    bochs-term
    bochs-doc
    bochsbios
    bximage
)

# QEMU targets for x86
QEMU_PKGS=(
    qemu-system-x86
    qemu-system-x86-xen
    qemu-system-gui
    qemu-block-extra
    qemu-utils
    qemu-kvm
    qemu-user
    qemu-user-static
)

# VNC related packages
VNC_SERVER_PKGS=(
    tightvncserver
    tigervnc-standalone-server
    tigervnc-tools
)
VNC_CLIENT_PKGS=(
    tigervnc-viewer
    gvncviewer
    xtightvncviewer
)
VNC_DEV_PKGS=(
    libvncserver-dev
    libgtk-vnc-2.0-dev
)

# Ensure apt-get is available
if ! command -v apt-get >/dev/null; then
    echo "apt-get not found. Install packages manually." >&2
    exit 1
fi

sudo apt-get update
sudo apt-get install -y \
    "${BUILD_PKGS[@]}" \
    "${BOCHS_PKGS[@]}" \
    "${QEMU_PKGS[@]}" \
    "${VNC_SERVER_PKGS[@]}" \
    "${VNC_CLIENT_PKGS[@]}" \
    "${VNC_DEV_PKGS[@]}"

# Create a disk image if missing
if [ ! -f fiwix.img ]; then
    echo "Creating 200MB disk image fiwix.img"
    bximage -func=create -hd=200 -imgmode=flat -q fiwix.img
fi

echo "Setup complete. Run ./run.sh to build and launch Fiwix."
