#!/usr/bin/env bash
# ==============================================================================
# run-kiwix-server.sh - Broadcast Offline Wikipedia & Knowledge over LAN/Wi-Fi
# Uses kiwix-serve container to serve all .zim files over standard HTTP (port 8080)
# ==============================================================================
set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ZIM_DIR="${1:-$VAULT_ROOT/05_NAS_HORDE/knowledge_maxi}"
PORT="${PORT:-8080}"

ENGINE="docker"
if command -v podman &>/dev/null; then
    ENGINE="podman"
fi

if [ ! -d "$ZIM_DIR" ] || [ -z "$(ls -A "$ZIM_DIR"/*.zim 2>/dev/null || true)" ]; then
    echo "Notice: No .zim files found in $ZIM_DIR. Checking 01_KNOWLEDGE..."
    ZIM_DIR="$VAULT_ROOT/01_KNOWLEDGE"
fi

echo "=== Starting Air-Gapped Kiwix Knowledge Web Server ==="
echo "Engine   : $ENGINE"
echo "Port     : $PORT"
echo "ZIM Dir  : $ZIM_DIR"
echo "--------------------------------------------------------"

$ENGINE rm -f kiwix-server 2>/dev/null || true

$ENGINE run -d \
    --name kiwix-server \
    --restart=always \
    -p "${PORT}:8080" \
    -v "${ZIM_DIR}:/data:ro" \
    ghcr.io/kiwix/kiwix-serve:latest \
    --port=8080 /data/*.zim

echo "✅ Kiwix Knowledge Server is live at: http://localhost:${PORT}"
echo "Any device on your Wi-Fi or LAN can now browse Wikipedia, WikiMed,"
echo "and survival guides directly in Chrome/Safari without installing an app!"
