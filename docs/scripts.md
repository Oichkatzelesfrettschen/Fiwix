Fiwix Kernel Script Documentation
This document provides a refined, comprehensive overview of the shell scripts and build system used for developing, building, and running the Fiwix kernel. It harmonizes legacy and modern practices, resolves inconsistencies, and elevates usability with clear usage examples, detailed explanations, and actionable recommendations. The scripts streamline dependency management, kernel compilation, and emulator execution, with a modern build.ninja configuration replacing the deprecated build.sh.
Introduction
The Fiwix kernel development workflow relies on a suite of scripts (fiwixctl.sh, run.sh, setup.sh, and .codex/setup.sh) and a Ninja-based build system (build.ninja) to manage dependencies, compile the kernel, and run it in emulators like QEMU or Bochs. This document synthesizes legacy and current approaches, offering a unified, developer-friendly reference for setup, building, and execution tasks.
Build System
Legacy: build.sh (Deprecated)

Purpose: A simple wrapper to compile the Fiwix kernel using all available CPU cores, supporting selectable build targets.
Usage (Legacy):./build.sh [target]


Status: Replaced by build.ninja for improved build performance and dependency management.
Migration Notes: Transition to the Ninja-based workflow outlined in build.md. The build.sh script is retained for historical reference but is no longer maintained.

Current: build.ninja

Purpose: A modern build configuration using Ninja to compile the Fiwix kernel, offering faster incremental builds and robust dependency tracking.
Key Features:
Parallel compilation utilizing all available CPU cores.
Configurable build targets for various kernel configurations.
Comprehensive documentation in build.md.


Usage:ninja -f build.ninja


Recommendations:
Install Ninja (sudo apt install ninja-build or equivalent) and review build.md for setup instructions.
Integrate into CI/CD pipelines for automated builds.
Regularly update build.ninja to reflect new kernel features.



fiwixctl.sh

Purpose: A unified helper script providing setup, build, and run commands to streamline the Fiwix kernel development workflow.
Commands:
setup: Installs build dependencies and configures the environment.
build: Compiles the kernel using build.ninja.
run: Launches the compiled kernel in QEMU or Bochs.


Usage Example:./fiwixctl.sh setup    # Install dependencies
./fiwixctl.sh build    # Compile kernel
./fiwixctl.sh run      # Run in QEMU


Features:
Simplifies multi-step workflows into single commands.
Supports flags for emulator selection and configuration (e.g., --emulator qemu).


Recommendations:
Add a --help flag to display detailed usage instructions.
Implement environment variable validation to prevent errors.
Consider adding a clean command to reset build artifacts.



run.sh

Purpose: Builds the Fiwix kernel and runs it in QEMU or Bochs, with optional emulator dependency installation.
Key Features:
Invokes build.ninja automatically before running.
Supports QEMU and Bochs with configurable parameters (e.g., memory, CPU settings).
Optionally installs emulator dependencies.


Usage Example:./run.sh --emulator qemu    # Run with QEMU
./run.sh --emulator bochs   # Run with Bochs
./run.sh --install-deps     # Install emulator dependencies


Recommendations:
Standardize emulator flags for consistent behavior.
Redirect emulator output to a log file for debugging.
Test compatibility with recent QEMU and Bochs versions.



setup.sh

Purpose: Installs build dependencies and creates an initial disk image for Fiwix kernel testing.
Key Features:
Installs required tools (e.g., GCC, Ninja, QEMU, Bochs).
Generates a bootable disk image for emulator use.


Usage Example:./setup.sh


Recommendations:
Add dependency version checks to ensure compatibility.
Support non-Debian systems (e.g., Fedora, Arch) with package manager detection.
Document disk image format and customization options in comments or build.md.



.codex/setup.sh

Purpose: Configures the Codex development environment, installing specific dependencies for Fiwix kernel development.
Usage:./.codex/setup.sh


Key Features:
Tailored for Codex-specific tools or configurations.
Complements setup.sh for specialized environments.


Recommendations:
Clarify Codex-specific dependencies and their role in the workflow.
Ensure compatibility with the main setup.sh to avoid conflicts.
Document prerequisites and environment setup steps.



Consolidated Recommendations

Build System Transition: Fully adopt build.ninja, archiving build.sh for historical reference. Update all documentation to reflect this shift.
Script Enhancements:
Implement robust error handling and user feedback in all scripts (e.g., check for missing tools).
Add --help flags with comprehensive usage details.
Enhance cross-platform support for broader usability (e.g., detect package managers like yum or pacman).


CI/CD Integration: Automate setup.sh, fiwixctl.sh, and run.sh in CI pipelines to validate builds and emulator runs across environments.
Documentation Improvements:
Link to build.md for Ninja-specific guidance.
Create a centralized README.md summarizing script roles and usage.
Include examples for common use cases (e.g., building for specific targets, running with custom emulator settings).


Testing and Validation:
Test scripts on multiple Linux distributions (e.g., Ubuntu, Fedora, Arch).
Verify compatibility with various QEMU/Bochs versions.
Add unit tests for scripts to ensure reliability.



References

Build Guide: build.md for Ninja-based build instructions.
Disk Image Specs: Check setup.sh comments for disk image details.
Emulator Configuration: Refer to QEMU and Bochs documentation for advanced options.
Codex Environment: See .codex/setup.sh comments for Codex-specific setup.

This refined document unifies legacy and modern practices, enhances clarity with structured examples, and resolves inconsistencies by emphasizing the build.ninja workflow while maintaining compatibility with existing scripts.