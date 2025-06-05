# Build, Test, Fuzz, Debug and Lint Requirements

This document summarizes the packages and tooling required to build and hack on
Fiwix as well as what would be needed to begin a port written in Go.

## Building the kernel

The kernel is written in C and targets the i386 architecture. Building requires
32‑bit development tools and a POSIX environment.

### Essential packages

- `build-essential` – provides `gcc`, `make` and basic development tools.
- `gcc-multilib` – allows building 32‑bit binaries on x86_64 hosts.
- `libc6-dev-i386` and `lib32gcc-s1` – 32‑bit C library headers and runtime.

Optional packages for alternate compilers or cross builds:

- `tcc` – if using TinyCC as described in `docs/tcc.txt`.
- `binutils` – for the linker and related utilities when cross compiling.
- `nix` – to use the `shell.nix` environment with cross tools.

### Additional tools

- `qemu-system-i386` or `bochs` – virtual machines to boot and test the kernel.
- `gdb` – debugging the kernel through a serial console or QEMU's built-in GDB
  server.
- `cscope` or `ctags` – convenient code navigation helpers.

## Testing and fuzzing

There are no automated tests, but the following tools can help:

- `qemu-system-i386` – quick boot testing of different configurations.
- `AFL` (American Fuzzy Lop) or `afl-clang-fast` – to fuzz system call entry
  points or filesystem parsers after crafting harnesses.
- `valgrind` – useful for user‑space utilities when building tools around Fiwix.

## Linting and static analysis

- `cppcheck` – static analysis for the C sources.
- `clang-tidy` – additional linting and modern C checking.
- `clang-format` – to enforce consistent formatting if desired.

## Debugging helpers

- `gdb` – remote debugging when running under QEMU/Bochs.
- `objdump`/`readelf` – inspecting the produced kernel binary.

## Libraries used by user space

Building a complete system requires standard POSIX tools and may use packages
such as `make`, `bash`, `coreutils` and `busybox` if assembling an initrd image.

## Starting a Go port

A full rewrite or partial port in Go would need the Go compiler and Go tooling
for cross compilation:

- `golang` or `gccgo` – a Go compiler capable of producing 32‑bit binaries.
- `go-tools` – standard Go toolchain including `go vet`, `gofmt` and modules.
- `cgo` enabled cross environment – to interface with existing C code if needed.
- Possible runtime support from `tinygo` or `gobootstrap` for minimal systems.

Cross compiling Go for i386 will require setting `GOARCH=386` and `GOOS` to a
suitable target. Additional libraries for hardware access, bootstrapping and
linker scripts would also be needed, but those depend on how the port evolves.

