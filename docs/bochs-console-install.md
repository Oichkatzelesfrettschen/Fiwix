# Installing Fiwix Using Bochs in a Text Environment

This guide shows how to configure Bochs entirely from the console. It uses the
curses interface by default and can optionally expose a VNC server for remote
viewing.

## Dependencies

Install Bochs, build, and VNC packages before continuing. The `setup.sh`
script installs everything automatically on Debian 12 or Ubuntu 24.04:

```bash
sudo apt-get update
sudo apt-get install gcc-multilib libc6-dev-i386 \
  bochs bochs-term bochs-x bochs-sdl bochsbios bximage \
  tightvncserver tigervnc-standalone-server tigervnc-tools \
  tigervnc-viewer gvncviewer xtightvncviewer \
  libvncserver-dev libgtk-vnc-2.0-dev
```

Or run the helper directly:

```bash
sudo ./setup.sh
```

## 1. Create a Disk Image

Use `bximage` to create a virtual hard disk. A 200MB flat image works well.
Download `FiwixOS.iso` from the official site yourself before installation.

```bash
bximage -hd -mode=flat -size=200 -q fiwix.img
```

## 2. Prepare `bochsrc`

A minimal configuration that uses the text interface is shown below. It boots
from the Fiwix ISO and logs to `bochs.log`.

```ini
# 128MB of memory
megs: 128

# System BIOS and VGA BIOS images
romimage: file=/usr/share/bochs/BIOS-bochs-latest
vgaromimage: file=/usr/share/vgabios/vgabios.bin

# Attach the install ISO and target disk
ata0-master: type=cdrom, path="FiwixOS.iso", status=inserted
ata0-slave:  type=disk, path="fiwix.img", mode=flat

# Boot from the CD
boot: cdrom

# Text configuration and curses display
config_interface: textconfig
display_library: term

# Record emulator output
log: bochs.log
```

To expose a VNC server instead, comment out the `display_library` line and use:

```ini
# display_library: rfb
```

## 3. Start Bochs

Run Bochs with the configuration file:

```bash
bochs -q -f bochsrc
```

Bochs will start in the curses interface. Follow the prompts to install Fiwix on
`fiwix.img`. When finished, update `bochsrc` to boot from the hard disk by
changing `boot: cdrom` to `boot: disk`.
