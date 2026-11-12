#!/usr/bin/env bash
# ==============================================================================
# run-offline-registry.sh - Launch an Air-Gapped Private Docker Registry
# Runs on port 5000 to serve container images to your local network without WAN
# ==============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="${1:-$DIR/registry_data}"
PORT="${PORT:-5000}"

ENGINE="docker"
if command -v podman &>/dev/null; then
    ENGINE="podman"
fi

mkdir -p "$DATA_DIR"

echo "=== Starting Air-Gapped Container Registry ==="
echo "Engine   : $ENGINE"
echo "Port     : $PORT"
echo "Storage  : $DATA_DIR"
echo "--------------------------------------------------------"

# Stop existing instance if running
$ENGINE rm -f local-registry 2>/dev/null || true

# Run registry
$ENGINE run -d \
    --name local-registry \
    --restart=always \
    -p "${PORT}:5000" \
    -v "${DATA_DIR}:/var/lib/registry:Z" \
    registry:2

echo "✅ Local registry is listening on 0.0.0.0:${PORT}"
echo ""
echo "How to use:"
echo "  1. Tag an image:"
echo "     $ENGINE tag my-app:latest localhost:${PORT}/my-app:latest"
echo "  2. Push to local registry:"
echo "     $ENGINE push localhost:${PORT}/my-app:latest"
echo "  3. Pull from any LAN device (e.g. 10.1.1.10):"
echo "     $ENGINE pull --tls-verify=false <THIS-HOST-IP>:${PORT}/my-app:latest"
