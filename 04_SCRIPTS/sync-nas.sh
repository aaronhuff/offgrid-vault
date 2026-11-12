#!/usr/bin/env bash
# ==============================================================================
# sync-nas.sh - Synchronize Off-Grid Vault directly to Synology DS220+
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAS_IP="${NAS_IP:-10.1.1.2}"
NAS_USER="${NAS_USER:-aaronhuff}"
NAS_PATH="${NAS_PATH:-/volume1/nfs/cold-vault}"

echo "=== Off-Grid Vault -> Synology NAS Direct Sync ==="
echo "Source : $VAULT_DIR"
echo "Target : ${NAS_USER}@${NAS_IP}:${NAS_PATH}"
echo "--------------------------------------------------------"

# Verify network & rsync capability
if ! ssh -o BatchMode=yes -o ConnectTimeout=5 "${NAS_USER}@${NAS_IP}" "rsync --version" &>/dev/null; then
    echo "Error: Cannot run rsync over SSH on ${NAS_USER}@${NAS_IP}."
    echo "Please ensure SSH and the rsync service are enabled in DSM (Control Panel -> File Services -> rsync)."
    exit 1
fi

echo "Ensuring target directory exists..."
ssh "${NAS_USER}@${NAS_IP}" "mkdir -p '${NAS_PATH}'"

echo "Starting synchronization..."
rsync -avh --no-perms --no-owner --no-group --progress --delete \
    --exclude='02_ENGINEERING/arduino/downloads/' \
    --exclude='*.tmp' \
    --exclude='.git/' \
    "$VAULT_DIR/" "${NAS_USER}@${NAS_IP}:${NAS_PATH}/"

echo "--------------------------------------------------------"
echo "✅ Synology NAS backup completed successfully!"
