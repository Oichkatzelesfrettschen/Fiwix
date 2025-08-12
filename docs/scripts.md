# Shell Script Overview

The legacy `build.sh` wrapper has been replaced by a `build.ninja`
configuration and accompanying `build.md` guide for Ninja-driven
builds of the Fiwix kernel.

## fiwixctl.sh
Unified helper supporting `setup`, `build`, and `run` commands to manage
dependencies, compile the kernel, and launch emulators.

## run.sh
Builds the kernel and runs it under QEMU or Bochs, optionally installing
emulator dependencies.

## setup.sh
Installs build dependencies and creates an initial disk image for Fiwix.
