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
