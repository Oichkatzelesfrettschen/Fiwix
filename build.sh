#!/bin/bash
# build.sh - simple build wrapper for the Fiwix kernel
# Usage: ./build.sh [target]
# Default target is 'all'.
set -euo pipefail

TARGET="${1:-all}"
make -j"$(nproc)" "$TARGET"
