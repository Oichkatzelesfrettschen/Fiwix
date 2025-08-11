# Shell Script Overview

## build.sh
Simple wrapper to build the Fiwix kernel with a selectable target using all available processors.

## fiwixctl.sh
Unified helper supporting `setup`, `build`, and `run` commands to manage dependencies, compile the kernel, and launch emulators.

## run.sh
Builds the kernel and runs it under QEMU or Bochs, optionally installing emulator dependencies.

## setup.sh
Installs build dependencies and creates an initial disk image for Fiwix.

