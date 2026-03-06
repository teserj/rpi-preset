#!/bin/bash
# =============================================================================
# Example User Setup Script: RISC-V GNU Toolchain
# =============================================================================
#
# This script demonstrates how to install a RISC-V toolchain at Docker build
# time using the USER_SETUP_SCRIPT build argument.
#
# Usage:
#   1. Place this script (or your own) in the user-scripts/ directory.
#   2. Build the container with the script name passed as a build arg:
#
#      docker build --build-arg USER_SETUP_SCRIPT=example-riscv-toolchain.sh -t rpi-debugbox .
#
#      Or via docker-compose, edit docker-compose.yml:
#        args:
#          USER_SETUP_SCRIPT: "example-riscv-toolchain.sh"
#
#   3. The script runs as root during the Docker build, so no sudo is needed.
#
# =============================================================================

set -e

echo ">>> Installing RISC-V toolchain via apt..."

# ---------------------------------------------------------------------------
# Option A: Install the distribution-packaged RISC-V cross-compiler (quick)
# ---------------------------------------------------------------------------
apt-get update && apt-get install -y --no-install-recommends \
    gcc-riscv64-linux-gnu \
    g++-riscv64-linux-gnu \
    binutils-riscv64-linux-gnu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

echo ">>> RISC-V cross-compiler installed:"
riscv64-linux-gnu-gcc --version | head -1

# ---------------------------------------------------------------------------
# Option B: Download a prebuilt toolchain archive (more complete, larger)
#
# Uncomment the block below if you need a specific version or the full
# baremetal (elf) toolchain that is not available via apt.
# ---------------------------------------------------------------------------

# RISCV_TOOLCHAIN_URL="https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/download/v13.2.0-2/xpack-riscv-none-elf-gcc-13.2.0-2-linux-arm64.tar.gz"
# RISCV_INSTALL_DIR="/opt/riscv-none-elf-gcc"
#
# echo ">>> Downloading prebuilt RISC-V toolchain..."
# mkdir -p "${RISCV_INSTALL_DIR}"
# curl -fSL "${RISCV_TOOLCHAIN_URL}" | tar -xz --strip-components=1 -C "${RISCV_INSTALL_DIR}"
#
# # Make the toolchain available on PATH for all users
# cat > /etc/profile.d/riscv-toolchain.sh << 'PROFILE_EOF'
# export PATH="/opt/riscv-none-elf-gcc/bin:${PATH}"
# PROFILE_EOF
# chmod +x /etc/profile.d/riscv-toolchain.sh
#
# # Also set PATH for non-login shells (e.g., docker exec)
# echo 'export PATH="/opt/riscv-none-elf-gcc/bin:${PATH}"' >> /etc/bash.bashrc
#
# echo ">>> Prebuilt RISC-V toolchain installed to ${RISCV_INSTALL_DIR}"

echo ">>> RISC-V toolchain setup complete."
