#!/usr/bin/env bash
# ==============================================================================
# flash-image.sh - Safe Air-Gapped Drive Flasher (Linux / CLI)
# Decompresses & writes ISOs or raw disk images (.img, .img.xz, .iso) to USB/SD
# ==============================================================================
set -euo pipefail

IMAGE="${1:-}"
TARGET="${2:-}"

if [ -z "$IMAGE" ]; then
    echo "Usage: sudo $0 <path-to-image> [target-device (e.g. /dev/sdb)]"
    echo ""
    echo "Available block devices on this system:"
    lsblk -d -o NAME,SIZE,TYPE,MODEL,TRAN | grep -E "disk"
    exit 1
fi

if [ ! -f "$IMAGE" ]; then
    echo "Error: Image file '$IMAGE' not found."
    exit 1
fi

if [ -z "$TARGET" ]; then
    echo "========================================================"
    echo "Available Removable Disks:"
    echo "========================================================"
    lsblk -o NAME,SIZE,TYPE,TRAN,MODEL,MOUNTPOINTS | grep -E "disk|NAME"
    echo ""
    read -rp "Enter target disk device (e.g. /dev/sdX - WARNING: WILL BE WIPED): " TARGET
fi

if [ ! -b "$TARGET" ]; then
    echo "Error: Target '$TARGET' is not a valid block device."
    exit 1
fi

# Safety guard against writing to system root
ROOT_DISK=$(lsblk -no PKNAME "$(findmnt -n -o SOURCE / 2>/dev/null || echo "")" 2>/dev/null || echo "")
if [[ "$TARGET" =~ $ROOT_DISK ]] && [ -n "$ROOT_DISK" ]; then
    echo "CRITICAL SAFETY ABORT: $TARGET appears to contain the active root filesystem!"
    exit 1
fi

echo "========================================================"
echo "TARGET DEVICE : $TARGET ($(lsblk -no SIZE "$TARGET" | head -n1))"
echo "IMAGE FILE    : $IMAGE ($(du -sh "$IMAGE" | cut -f1))"
echo "========================================================"
read -rp "ARE YOU SURE? All data on $TARGET will be permanently destroyed! (yes/NO): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Aborted by user."
    exit 0
fi

echo "Unmounting any existing partitions on $TARGET..."
for part in "${TARGET}"*; do
    if [ -b "$part" ] && [ "$part" != "$TARGET" ]; then
        sudo umount "$part" 2>/dev/null || true
    fi
done

echo "Writing image to $TARGET with direct sync..."
if [[ "$IMAGE" =~ \.xz$ ]]; then
    echo "Streaming decompress (.xz) directly to disk..."
    xz -dc "$IMAGE" | sudo dd of="$TARGET" bs=4M status=progress conv=fsync
elif [[ "$IMAGE" =~ \.gz$ ]]; then
    gzip -dc "$IMAGE" | sudo dd of="$TARGET" bs=4M status=progress conv=fsync
else
    sudo dd if="$IMAGE" of="$TARGET" bs=4M status=progress conv=fsync
fi

sudo sync
echo "========================================================"
echo "Flashing complete! Drive safely synced. You may now remove $TARGET."
echo "========================================================"
