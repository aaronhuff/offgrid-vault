#!/usr/bin/env bash
# ==============================================================================
# bundle-offline-containers.sh - Air-Gapped Container Image Packager
# Exports essential container images to compressed tarballs for offline import
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR="${1:-$VAULT_ROOT/00_BOOTSTRAP/container_images}"

mkdir -p "$TARGET_DIR"

echo "========================================================"
echo "Packaging Air-Gapped Container Images"
echo "Target Directory: $TARGET_DIR"
echo "========================================================"

export_image() {
    local image="$1"
    local output="$2"
    if [ -f "$output" ] && [ -s "$output" ]; then
        echo "Already exported: $(basename "$output") ($(du -sh "$output" | cut -f1))"
        return 0
    fi
    echo "Exporting $image -> $(basename "$output")..."
    if command -v podman &>/dev/null; then
        podman save "$image" | gzip > "$output"
    elif command -v docker &>/dev/null; then
        docker save "$image" | gzip > "$output"
    else
        echo "Error: Neither podman nor docker found."
        exit 1
    fi
}

# 1. Kiwix Serve (Serves Wikipedia & medical ZIMs to LAN browsers)
export_image "ghcr.io/kiwix/kiwix-serve:latest" "$TARGET_DIR/kiwix-serve.tar.gz"

# 2. Local Container Registry (Private offline docker registry on port 5000)
export_image "docker.io/library/registry:2" "$TARGET_DIR/registry-v2.tar.gz"

# 3. Caddy Server (Offline reverse proxy & static portal)
export_image "docker.io/library/caddy:alpine" "$TARGET_DIR/caddy-alpine.tar.gz"

# 4. Alpine Linux (Ultra-lightweight micro container)
export_image "docker.io/library/alpine:latest" "$TARGET_DIR/alpine.tar.gz"

# 5. Ubuntu Noble (Standard build & rescue environment)
export_image "docker.io/library/ubuntu:noble" "$TARGET_DIR/ubuntu-noble.tar.gz"

# Generate IMPORT_ALL.sh script
cat << 'EOF' > "$TARGET_DIR/IMPORT_ALL.sh"
#!/usr/bin/env bash
# Air-Gapped Container Importer (Runs on any machine with Docker or Podman)
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ENGINE="docker"
if command -v podman &>/dev/null; then
    ENGINE="podman"
elif ! command -v docker &>/dev/null; then
    echo "Error: Neither podman nor docker found."
    exit 1
fi

echo "Importing offline container images using $ENGINE..."
for archive in "$DIR"/*.tar.gz; do
    if [ -f "$archive" ]; then
        echo "Loading $(basename "$archive")..."
        gzip -dc "$archive" | $ENGINE load
    fi
done
echo "All offline container images loaded successfully into $ENGINE!"
$ENGINE images
EOF
chmod +x "$TARGET_DIR/IMPORT_ALL.sh"

echo "========================================================"
echo "Container package complete at: $TARGET_DIR"
echo "Total size: $(du -sh "$TARGET_DIR" | cut -f1)"
echo "To import on an offline machine: cd $TARGET_DIR && ./IMPORT_ALL.sh"
echo "========================================================"
