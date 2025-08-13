Fiwix Kernel Shell Script Overview
This document consolidates and enhances the overview of shell scripts used for building, managing, and running the Fiwix kernel. It harmonizes legacy and updated build processes, resolves inconsistencies, and provides clear guidance for developers. The scripts streamline dependency management, kernel compilation, and emulator execution, with a shift from build.sh to a modern build.ninja configuration.
Introduction
The Fiwix kernel development workflow relies on shell scripts (fiwixctl.sh, run.sh, setup.sh) and a Ninja-based build system (build.ninja) to manage dependencies, compile the kernel, and run it in emulators like QEMU or Bochs. This document synthesizes legacy and current practices, offering a unified reference for setup, building, and execution tasks.
Build System
Legacy: build.sh (Deprecated)

Purpose: A simple wrapper to compile the Fiwix kernel using all available processors, with selectable build targets.
Status: Replaced by build.ninja for improved build efficiency and reproducibility.
Migration Notes: Users of build.sh should transition to the Ninja-driven workflow described in build.md. The legacy script is retained for reference but is no longer maintained.

Current: build.ninja

Purpose: A modern build configuration using Ninja to compile the Fiwix kernel, offering faster incremental builds and better dependency tracking.
Key Features:
Parallel compilation leveraging all available processors.
Configurable build targets for different kernel configurations.
Detailed guidance in build.md for setup and execution.


Usage:ninja -f build.ninja


Recommendations:
Review build.md for prerequisites and advanced configuration options.
Ensure Ninja is installed (sudo apt install ninja-build or equivalent).
Integrate into CI pipelines for automated builds.



fiwixctl.sh

Purpose: A unified helper script providing setup, build, and run commands to streamline Fiwix kernel development.
Commands:
setup: Installs build dependencies and prepares the development environment.
build: Compiles the kernel using the Ninja build system.
run: Launches the compiled kernel in an emulator (QEMU or Bochs).


Usage Example:./fiwixctl.sh setup    # Install dependencies
./fiwixctl.sh build    # Compile kernel
./fiwixctl.sh run      # Run in QEMU


Features:
Simplifies workflow by combining setup, build, and run tasks.
Supports command-line flags for emulator selection and configuration.


Recommendations:
Add inline help (./fiwixctl.sh --help) to document available options.
Validate environment variables to prevent misconfigurations.
Consider adding a clean command to reset the build environment.



run.sh

Purpose: Builds the Fiwix kernel and runs it under QEMU or Bochs, with optional emulator dependency installation.
Key Features:
Automatically invokes the Ninja build system before running.
Supports QEMU and Bochs with configurable parameters (e.g., memory, CPU).
Installs emulator dependencies if missing (optional flag).


Usage Example:./run.sh --emulator qemu    # Run with QEMU
./run.sh --emulator bochs   # Run with Bochs
./run.sh --install-deps     # Install emulator dependencies


Recommendations:
Standardize emulator flags for consistency across runs.
Log emulator output to a file for debugging.
Test compatibility with multiple QEMU/Bochs versions.



setup.sh

Purpose: Installs build dependencies and creates an initial disk image for the Fiwix kernel.
Key Features:
Installs required tools (e.g., GCC, Ninja, QEMU, Bochs).
Generates a bootable disk image for emulator testing.


Usage Example:./setup.sh


Recommendations:
Add version checks for dependencies to ensure compatibility.
Support non-Debian systems (e.g., Fedora, Arch) with package manager detection.
Document disk image format and customization options.



Consolidated Recommendations

Migration to Ninja: Fully transition from build.sh to build.ninja by updating all workflows and documentation. Archive build.sh for historical reference.
Script Enhancements:
Add error handling and user feedback in all scripts (e.g., check for missing tools).
Implement --help flags with detailed usage instructions.
Support cross-platform compatibility for broader adoption.


CI/CD Integration: Automate setup.sh, fiwixctl.sh build, and run.sh in CI pipelines to validate builds and emulator runs.
Documentation:
Link to build.md for Ninja-specific instructions.
Create a centralized README.md referencing all scripts and their roles.


Testing: Validate scripts across different Linux distributions and emulator versions to ensure robustness.

References

Build Guide: See build.md for Ninja-based build instructions.
Disk Image: Refer to setup.sh comments for disk image specifications.
Emulator Options: Check QEMU/Bochs documentation for advanced configuration.

This document unifies legacy and modern build practices, elevates usability with clear examples, and resolves inconsistencies by prioritizing build.ninja while retaining compatibility with existing scripts.