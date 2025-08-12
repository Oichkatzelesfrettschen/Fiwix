# Fiwix Kernel Build Guide

This repository previously included a `build.sh` helper script. The
kernel can now be compiled directly with [Ninja](https://ninja-build.org),
which orchestrates the existing `Makefile`.

## Prerequisites

Ensure the build tools are installed:

```bash
sudo apt-get install build-essential ninja-build
```

## Building

The `build.ninja` file invokes `make` with optimal parallelism. Invoke
Ninja from the repository root to produce the kernel image:

```bash
ninja
```

To clean generated artifacts:

```bash
ninja clean
```

Additional `make` targets can be added to `build.ninja` following the
existing pattern.
