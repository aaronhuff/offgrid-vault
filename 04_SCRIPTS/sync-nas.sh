#!/usr/bin/env bash
# ==============================================================================
# sync-nas.sh - Synchronize Off-Grid Vault to Synology DS220+ (10.1.1.2)
# ==============================================================================
set -euo pipefail

NAS_IP="${NAS_IP:-10.1.1.2}"
NAS_USER="${NAS_USER:-aaronhuff}"
NAS_PATH="${NAS_PATH:-/volume1/cold-vault}"
VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Off-Grid Vault -> Synology NAS Sync ==="
echo "Source : $VAULT_DIR"
echo "Target : ${NAS_USER}@${NAS_IP}:${NAS_PATH}"
echo "--------------------------------------------------------"

# Verify network reachability
if ! nc -z -w 3 "$NAS_IP" 22 &>/dev/null; then
    echo "Error: Cannot reach NAS SSH port 22 on $NAS_IP."
    exit 1
fi

echo "Testing / creating target folder on NAS..."
ssh -o BatchMode=yes -o ConnectTimeout=5 "${NAS_USER}@${NAS_IP}" "mkdir -p '${NAS_PATH}'" || {
    echo "Notice: Non-interactive SSH failed. Will attempt rsync with interactive prompt if needed."
}

echo "Starting synchronization..."
rsync -avh --progress --delete \
    --exclude='02_ENGINEERING/arduino/downloads/' \
    --exclude='*.tmp' \
    "$VAULT_DIR/" "${NAS_USER}@${NAS_IP}:${NAS_PATH}/"

echo "--------------------------------------------------------"
echo "NAS backup completed successfully!"
