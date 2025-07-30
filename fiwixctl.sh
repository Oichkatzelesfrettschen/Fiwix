#!/bin/bash
# fiwixctl.sh - unified helper for building, running and setting up Fiwix
# Usage: ./fiwixctl.sh <command>
# Commands:
#   setup   Install required packages and create a disk image
#   build   Build the kernel (default target 'all')
#   run     Build and launch the kernel under an emulator

set -euo pipefail

command=${1:-}
shift || true

BUILD_PKGS=(gcc-multilib libc6-dev-i386)
BOCHS_PKGS=(bochs bochs-sdl bochs-wx bochs-x bochs-term bochs-doc bochsbios bximage)
QEMU_PKGS=(qemu-system-x86 qemu-system-x86-xen qemu-system-gui qemu-block-extra qemu-utils qemu-kvm qemu-user qemu-user-static)
VNC_SERVER_PKGS=(tightvncserver tigervnc-standalone-server tigervnc-tools)
VNC_CLIENT_PKGS=(tigervnc-viewer gvncviewer xtightvncviewer)
VNC_DEV_PKGS=(libvncserver-dev libgtk-vnc-2.0-dev)

run_build() {
    target=${1:-all}
    make -j"$(nproc)" "$target"
}

run_setup() {
    if command -v apt-get >/dev/null; then
        sudo apt-get update
        sudo apt-get install -y \
            "${BUILD_PKGS[@]}" \
            "${BOCHS_PKGS[@]}" \
            "${QEMU_PKGS[@]}" \
            "${VNC_SERVER_PKGS[@]}" \
            "${VNC_CLIENT_PKGS[@]}" \
            "${VNC_DEV_PKGS[@]}"
    fi
    if [ ! -f fiwix.img ]; then
        echo "Creating 200MB disk image fiwix.img"
        bximage -func=create -hd=200 -imgmode=flat -q fiwix.img
    fi
}

run_run() {
    run_build
    EMU=${EMU:-bochs}
    case "$EMU" in
        qemu)
            qemu-system-i386 -display curses -serial stdio -kernel fiwix -append "console=ttyS0" -d guest_errors -D qemu.log
            ;;
        bochs)
            bochs -q -f bochsrc
            ;;
        *)
            echo "Unsupported emulator: $EMU" >&2
            exit 1
            ;;
    esac
}

case "$command" in
    setup)
        run_setup
        ;;
    build)
        run_build "$@"
        ;;
    run)
        run_run
        ;;
    *)
        echo "Usage: $0 {setup|build|run}" >&2
        exit 1
        ;;
esac
