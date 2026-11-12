#!/usr/bin/env bash
# ==============================================================================
# sync-vault.sh - Sync the Golden Master Vault to Portable Media
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
    cat <<EOF
Usage: $0 --profile <sd32|usb128|ventoy|sata|nas> --target <mount_path> [--dry-run]

Profiles:
  sd32    : Pocket Emergency (APKs, WikiMed, WikiHow, PDFs) [< 29GB]
  usb128  : Full Engineering (sd32 + Arduino IDE, GGUF LLMs, CHIRP, Repos) [< 118GB]
  ventoy  : Rugged Multi-Boot Drive (Bootable ISOs + Civilian Pack + Tools)
  sata    : Full Master Mirror (1:1 copy of entire vault)
  nas     : Backup to Synology NAS share

Options:
  --dry-run : Show what would be transferred without writing
  -h, --help: Show this help message
EOF
    exit 1
}

PROFILE=""
TARGET=""
DRY_RUN=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --profile)
            PROFILE="$2"
            shift 2
            ;;
        --target)
            TARGET="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN="--dry-run"
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

if [[ -z "$PROFILE" || -z "$TARGET" ]]; then
    echo "Error: Both --profile and --target are required."
    usage
fi

if [[ ! -d "$TARGET" ]]; then
    echo "Error: Target directory '$TARGET' does not exist."
    exit 1
fi

RSYNC_FLAGS="-avh --progress --modify-window=1 --delete"
if [[ -n "$DRY_RUN" ]]; then
    RSYNC_FLAGS="$RSYNC_FLAGS $DRY_RUN"
    echo "=== RUNNING IN DRY-RUN MODE (No files will be modified) ==="
fi

echo "Source Vault: $VAULT_DIR"
echo "Target Path : $TARGET"
echo "Profile     : $PROFILE"
echo "--------------------------------------------------------"

case "$PROFILE" in
    sd32)
        echo "Syncing Pocket Survival Profile (sd32)..."
        rsync $RSYNC_FLAGS \
            --include='00_BOOTSTRAP/' \
            --include='00_BOOTSTRAP/apks/***' \
            --include='01_KNOWLEDGE/' \
            --include='01_KNOWLEDGE/manuals_pdf/***' \
            --include='01_KNOWLEDGE/kindle_books/***' \
            --include='01_KNOWLEDGE/zim/' \
            --include='01_KNOWLEDGE/zim/*medicine*.zim' \
            --include='01_KNOWLEDGE/zim/*wikihow*.zim' \
            --include='MANIFEST.md' \
            --exclude='*' \
            "$VAULT_DIR/" "$TARGET/"
        ;;
    usb128)
        echo "Syncing Engineering & AI Profile (usb128)..."
        rsync $RSYNC_FLAGS \
            --exclude='03_INTELLIGENCE/models_7b/*fp16*' \
            --exclude='*.iso' \
            "$VAULT_DIR/" "$TARGET/"
        ;;
    ventoy)
        echo "Syncing Rugged Ventoy Faraday Key Profile..."
        mkdir -p "$TARGET/ISOs"
        # 1. Sync Bootable ISOs from local vault and NAS mirror if available
        if [ -d "$VAULT_DIR/05_NAS_HORDE/isos" ]; then
            echo "Copying local ISOs to /ISOs/..."
            find "$VAULT_DIR/05_NAS_HORDE/isos" -type f -name "*.iso" -exec cp -u {} "$TARGET/ISOs/" \; 2>/dev/null || true
        fi
        # 2. Sync Tools, Civilian Seed Pack, Packages, Books, and Radio data
        echo "Copying Civilian Seed Pack, Tools, and Packages..."
        rsync $RSYNC_FLAGS \
            --include='00_CIVILIAN_SEED_PACK/***' \
            --include='00_BOOTSTRAP/***' \
            --include='01_KNOWLEDGE/kindle_books/***' \
            --include='02_ENGINEERING/radio_chirp/***' \
            --include='04_SCRIPTS/flash-image.sh' \
            --include='README.md' \
            --include='CHECKLIST.md' \
            --exclude='*' \
            "$VAULT_DIR/" "$TARGET/Vault_Tools/"
        ;;
    sata|nas)
        echo "Syncing Full Mirror Profile ($PROFILE)..."
        rsync $RSYNC_FLAGS \
            "$VAULT_DIR/" "$TARGET/"
        ;;
    *)
        echo "Error: Invalid profile '$PROFILE'."
        usage
        ;;
esac

echo "--------------------------------------------------------"
echo "Sync complete!"
if [[ -z "$DRY_RUN" ]]; then
    sync
    echo "Target synced to physical disk."
fi
