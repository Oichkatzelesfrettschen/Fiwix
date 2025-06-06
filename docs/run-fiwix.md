# Running Fiwix with QEMU or Bochs

This guide explains how to build the kernel and launch it under an emulator. Use
the provided `setup.sh` to install packages on Debian 12 or Ubuntu 24.04, then
run `run.sh` or the `make run` target.

## Setup

Run the helper below to install all dependencies and create a starter disk
image:

```bash
sudo ./setup.sh
```

The script uses `apt-get` and works on both Debian 12 and Ubuntu 24.04.

## Build and Run

```bash
# Compile the kernel and launch Bochs (default)
make run

# Use QEMU instead
make EMU=qemu run
```

The `run.sh` helper respects the `EMU` environment variable. When set to
`bochs`, it starts Bochs using `bochsrc` with a curses display. With
`EMU=qemu`, it launches `qemu-system-i386` using `-display curses` and logs to
`qemu.log`.

Both emulators require 32-bit support packages. The build may succeed but the emulator might not run in restricted environments.

The helper script automatically creates `fiwix.img` if it is not present. You
must provide `FiwixOS.iso` yourself to install the system when using Bochs.


## Installing Emulator Packages

Use `apt-get` to install build tools plus Bochs, QEMU and VNC packages. The `run.sh` script
attempts this automatically, but you can do it manually as well:

```bash
sudo apt-get update
sudo apt-get install gcc-multilib libc6-dev-i386 \
  bochs bochs-sdl bochs-wx bochs-x bochs-term bochs-doc \
  bochsbios bximage \
  qemu-system-x86 qemu-system-x86-xen qemu-system-gui \
  qemu-block-extra qemu-utils qemu-kvm \
  qemu-user qemu-user-static \
  tightvncserver tigervnc-standalone-server tigervnc-tools \
  tigervnc-viewer gvncviewer xtightvncviewer \
  libvncserver-dev libgtk-vnc-2.0-dev
```

In restricted environments the installation may fail; the kernel build can still
succeed but the emulator might not run.
