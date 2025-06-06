#!/bin/bash
# run.sh - build and run Fiwix under QEMU or Bochs.
# Usage: EMU=qemu ./run.sh
set -euo pipefail

# Package lists used to prepare the emulators and optional VNC support
# Build tools for compiling a 32-bit kernel
BUILD_PKGS=(
    gcc-multilib
    libc6-dev-i386
)
# Bochs and build helpers
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
# QEMU with x86 targets
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
# VNC servers, viewers and development headers
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

# Try to install dependencies. This may fail in restricted environments.
if command -v apt-get >/dev/null; then
    apt-get update
    apt-get install -y \
        "${BUILD_PKGS[@]}" \
        "${BOCHS_PKGS[@]}" \
        "${QEMU_PKGS[@]}" \
        "${VNC_SERVER_PKGS[@]}" \
        "${VNC_CLIENT_PKGS[@]}" \
        "${VNC_DEV_PKGS[@]}" || true
fi

# Emulator to launch, defaults to Bochs
EMU=${EMU:-bochs}

# Build the kernel using every available processor
make -j"$(nproc)" all

# Ensure a disk image exists for Bochs
if [ ! -f fiwix.img ]; then
    echo "Creating default disk image fiwix.img"
    bximage -func=create -hd=200 -imgmode=flat -q fiwix.img
fi

# Installation media is expected to be present as FiwixOS.iso
# Run the selected emulator
case "$EMU" in
    qemu)
        # Boot the kernel using QEMU in a curses console
        qemu-system-i386 \
            -display curses \
            -serial stdio \
            -kernel fiwix \
            -append "console=ttyS0" \
            -d guest_errors \
            -D qemu.log
        ;;
    bochs)
        # Launch Bochs using the provided configuration file
        bochs -q -f bochsrc
        ;;
    *)
        echo "Unsupported emulator: $EMU" >&2
        exit 1
        ;;
esac
