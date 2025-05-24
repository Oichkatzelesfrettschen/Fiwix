#!/bin/bash
set -e

# Install packages needed for 32-bit build of Fiwix
apt-get update
apt-get install -y build-essential gcc-multilib libc6-dev-i386 lib32gcc-s1
