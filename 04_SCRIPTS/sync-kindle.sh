#!/usr/bin/env bash
# ==============================================================================
# sync-kindle.sh - Zap ePubs and PDFs directly onto a connected Kindle over USB
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BOOKS_DIR="$VAULT_DIR/01_KNOWLEDGE/kindle_books"
MANUALS_DIR="$VAULT_DIR/01_KNOWLEDGE/manuals_pdf"

# Auto-detect mounted Kindle or accept path as $1
KINDLE_PATH="${1:-}"

if [[ -z "$KINDLE_PATH" ]]; then
    # Look for common Kindle mountpoints on Linux / Fedora / Bluefin
    for mount in /run/media/"$USER"/Kindle* /media/"$USER"/Kindle* /mnt/Kindle*; do
        if [[ -d "$mount/documents" ]]; then
            KINDLE_PATH="$mount"
            break
        fi
    done
fi

if [[ -z "$KINDLE_PATH" || ! -d "$KINDLE_PATH/documents" ]]; then
    echo "========================================================"
    echo "Error: Kindle not found or 'documents' folder missing."
    echo "========================================================"
    echo "1. Connect your Kindle to your laptop via USB cable."
    echo "2. Unlock the Kindle screen if prompted to allow USB access."
    echo "3. Run this script with the mount path, for example:"
    echo "   $0 /run/media/$USER/Kindle"
    echo "========================================================"
    exit 1
fi

TARGET_DOCS="$KINDLE_PATH/documents"
echo "Kindle detected at: $KINDLE_PATH"
echo "Syncing books to : $TARGET_DOCS"
echo "--------------------------------------------------------"

# Sync all ePubs and PDFs (recursing into subfolders like classics/)
rsync -avh --progress --modify-window=1 \
    --include='*/' \
    --include='*.epub' \
    --include='*.azw3' \
    --include='*.kfx' \
    --include='*.mobi' \
    --include='*.pdf' \
    --exclude='*' \
    "$BOOKS_DIR/" "$TARGET_DOCS/"

if [[ -d "$MANUALS_DIR" ]]; then
    echo "Syncing field manuals..."
    rsync -avh --progress --modify-window=1 \
        --include='*/' \
        --include='*.pdf' \
        --include='*.epub' \
        --exclude='*' \
        "$MANUALS_DIR/" "$TARGET_DOCS/"
fi

sync
echo "--------------------------------------------------------"
echo "Done! All books zapped to Kindle. Safe to eject/unplug USB."
