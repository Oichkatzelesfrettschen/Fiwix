# Script Documentation

This project includes helper scripts for building and running the Fiwix kernel. Each
script is briefly described below.

## `build.sh`
Builds the kernel using all available CPU cores:

```bash
./build.sh [target]
```

## `run.sh`
Builds the kernel and launches it under QEMU or Bochs:

```bash
EMU=qemu ./run.sh
```

## `setup.sh`
Installs build dependencies and creates a disk image:

```bash
./setup.sh
```

## `fiwixctl.sh`
Unified helper providing `setup`, `build` and `run` commands:

```bash
./fiwixctl.sh <command>
```

## `.codex/setup.sh`
Sets up dependencies for the Codex development environment:

```bash
./.codex/setup.sh
```

