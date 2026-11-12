#!/usr/bin/env bash
# ==============================================================================
# sync-nas.sh - Synchronize Off-Grid Vault to Synology DS220+ Persistence Anchor
# Uses direct SSH to Synology (10.1.1.2) if authorized, or falls back seamlessly
# to the lab storage gateway (rpi5: 10.1.1.11:/mnt/nas/cold-vault)
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Target configuration
NAS_DIRECT_IP="10.1.1.2"
GATEWAY_IP="10.1.1.11"
USER_NAME="aaronhuff"

echo "=== Off-Grid Vault -> Synology NAS Synchronization ==="
echo "Source: $VAULT_DIR"

# 1. Check if direct SSH to Synology NAS is authorized
if ssh -o BatchMode=yes -o ConnectTimeout=3 "${USER_NAME}@${NAS_DIRECT_IP}" "true" 2>/dev/null; then
    TARGET_HOST="${NAS_DIRECT_IP}"
    TARGET_PATH="/volume1/cold-vault"
    echo "Mode: Direct Synology DSM SSH (${TARGET_HOST}:${TARGET_PATH})"
# 2. Check if Raspberry Pi 5 storage gateway is reachable
elif ssh -o BatchMode=yes -o ConnectTimeout=3 "${USER_NAME}@${GATEWAY_IP}" "true" 2>/dev/null; then
    TARGET_HOST="${GATEWAY_IP}"
    TARGET_PATH="/mnt/nas/cold-vault"
    echo "Mode: High-Speed Storage Gateway -> Synology NFS (${TARGET_HOST}:${TARGET_PATH})"
else
    echo "Error: Neither direct NAS (${NAS_DIRECT_IP}) nor gateway (${GATEWAY_IP}) is reachable with passwordless SSH."
    echo ""
    echo "To fix permissions:"
    echo "  1. Sync your lab SSH key: ~/repos/home-lab/scripts/maintenance/sync_ssh_keys.sh"
    echo "  2. For direct Synology SSH: ssh-copy-id ${USER_NAME}@${NAS_DIRECT_IP}"
    exit 1
fi

echo "Ensuring target directory exists..."
ssh "${USER_NAME}@${TARGET_HOST}" "mkdir -p '${TARGET_PATH}'"

echo "--------------------------------------------------------"
echo "Starting synchronization..."
rsync -avh --progress --delete \
    --exclude='02_ENGINEERING/arduino/downloads/' \
    --exclude='*.tmp' \
    --exclude='.git/' \
    "$VAULT_DIR/" "${USER_NAME}@${TARGET_HOST}:${TARGET_PATH}/"

echo "--------------------------------------------------------"
echo "✅ Synology NAS backup completed successfully to ${TARGET_HOST}:${TARGET_PATH}!"
