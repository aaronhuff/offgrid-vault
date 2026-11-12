#!/usr/bin/env bash
# ==============================================================================
# download-offline-debs.sh - Download Curated Offline .deb Package Bundle
# Solves the air-gap package installation dilemma for Debian/Ubuntu systems
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR="${1:-$VAULT_ROOT/00_BOOTSTRAP/packages/ubuntu_noble_core}"

mkdir -p "$TARGET_DIR"

echo "========================================================"
echo "Downloading Resolved Offline .deb Bundle (Ubuntu 24.04 Noble)"
echo "Target: $TARGET_DIR"
echo "Includes: build-essential (gcc/g++/make), wireguard-tools,"
echo "          git, rsync, tmux, htop, minicom, python3-venv"
echo "========================================================"

podman run --rm -v "$TARGET_DIR:/target:Z" docker.io/library/ubuntu:noble bash -c '
    set -euo pipefail
    mkdir -p /tmp/debs/partial
    apt-get update -qq
    echo "Resolving and downloading packages with complete dependency graph..."
    apt-get install --download-only -y -o Dir::Cache::archives=/tmp/debs \
        build-essential \
        wireguard-tools \
        tmux \
        git \
        rsync \
        htop \
        minicom \
        python3-venv \
        ca-certificates \
        curl
    cp /tmp/debs/*.deb /target/
    echo "Downloaded $(ls -1 /target/*.deb | wc -l) packages ($(du -sh /target | cut -f1))"
'

cat << 'EOF' > "$TARGET_DIR/INSTALL.sh"
#!/usr/bin/env bash
# Air-gapped offline package installer
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Installing offline deb packages..."
sudo dpkg -i "$DIR"/*.deb || sudo apt-get install -f -y --no-download
echo "Offline packages installed successfully!"
EOF
chmod +x "$TARGET_DIR/INSTALL.sh"

echo "========================================================"
echo "Offline .deb bundle ready at: $TARGET_DIR"
echo "To install on an offline machine: sudo ./INSTALL.sh"
echo "========================================================"
