#!/usr/bin/env bash
# ==============================================================================
# flash-mesh-node.sh - Air-Gapped MeshCore & Meshtastic Firmware Flasher
# Uses cached Python wheels (esptool + pyserial) or UF2 mass-storage flashing.
# ==============================================================================
set -euo pipefail

LORA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_DIR="$(cd "$LORA_DIR/../.." && pwd)"
WHEELS_DIR="$VAULT_DIR/02_ENGINEERING/python_wheels"

usage() {
    cat <<EOF
Usage:
  $0 --list
  $0 --port <serial_or_uf2_mount> --firmware <path_to_bin_or_uf2> [--erase]

Examples:
  # List cached MeshCore & Meshtastic firmwares and connected devices
  $0 --list

  # Flash Heltec V4 as MeshCore Room Server (recommended --erase when switching from Meshtastic)
  $0 --port /dev/ttyACM0 --firmware ./02_ENGINEERING/lora_mesh/meshcore/heltec_v4_room_server-v1.18.0-81dbae5-merged.bin --erase

  # Flash an nRF52840 UF2 target (T1000-E or RAK4631) mounted in bootloader mode
  $0 --port /run/media/\$USER/T1000-E --firmware ./02_ENGINEERING/lora_mesh/meshcore/t1000e_companion_radio_ble-v1.18.0-81dbae5.uf2
EOF
    exit 1
}

ensure_esptool() {
    if python3 -m esptool version &>/dev/null && python3 -c "import serial" &>/dev/null; then
        return 0
    fi
    echo "Installing esptool & pyserial offline from $WHEELS_DIR..."
    if [ ! -d "$WHEELS_DIR" ]; then
        echo "Error: Offline wheelhouse not found at $WHEELS_DIR" >&2
        exit 1
    fi
    python3 -m pip install --user --no-index --find-links="$WHEELS_DIR" pyserial esptool
}

list_inventory() {
    echo "=== Cached MeshCore Firmwares ==="
    if [ -d "$LORA_DIR/meshcore" ]; then
        find "$LORA_DIR/meshcore" -maxdepth 1 -type f \( -name "*.bin" -o -name "*.uf2" \) | sort | sed "s|$VAULT_DIR/|./|"
    else
        echo "  (none yet — run ./04_SCRIPTS/download-mesh-firmware.sh)"
    fi

    echo ""
    echo "=== Cached Meshtastic Extracted Images ==="
    if [ -d "$LORA_DIR/meshtastic/extracted" ]; then
        find "$LORA_DIR/meshtastic/extracted" -maxdepth 1 -type f \( -name "*.bin" -o -name "*.uf2" \) | sort | sed "s|$VAULT_DIR/|./|"
    else
        echo "  (none yet — run ./04_SCRIPTS/download-mesh-firmware.sh)"
    fi

    echo ""
    echo "=== Detected Serial Ports ==="
    ls -la /dev/ttyACM* /dev/ttyUSB* 2>/dev/null || echo "  No USB serial devices detected."

    echo ""
    echo "=== Detected Removable / UF2 Mounts ==="
    ls -d /run/media/"$USER"/* /media/*/* 2>/dev/null || echo "  No removable volumes mounted."
}

PORT=""
FIRMWARE=""
ERASE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --list)
            list_inventory
            exit 0
            ;;
        --port)
            PORT="${2:-}"
            shift 2
            ;;
        --firmware)
            FIRMWARE="${2:-}"
            shift 2
            ;;
        --erase)
            ERASE=true
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

if [ -z "$PORT" ] || [ -z "$FIRMWARE" ]; then
    usage
fi

if [ ! -f "$FIRMWARE" ]; then
    echo "Error: Firmware file '$FIRMWARE' not found." >&2
    exit 1
fi

echo "========================================================"
echo "Firmware : $FIRMWARE ($(du -sh "$FIRMWARE" | cut -f1))"
echo "Target   : $PORT"
echo "Erase    : $ERASE"
echo "========================================================"

if [[ "$FIRMWARE" == *.uf2 ]]; then
    if [ -d "$PORT" ]; then
        echo "Copying UF2 image to bootloader drive '$PORT'..."
        cp -v "$FIRMWARE" "$PORT/"
        sync
        echo "✅ UF2 copied! The board will reboot automatically."
    else
        echo "UF2 targets (T1000-E, RAK4631) flash via USB mass-storage bootloader:"
        echo "  1. Double-tap Reset (or connect T1000-E magnetic cable while holding button) until a USB drive appears."
        echo "  2. Copy '$FIRMWARE' onto the mounted UF2 drive, or re-run with --port /path/to/mounted/UF2_DRIVE."
    fi
    exit 0
fi

if [ ! -c "$PORT" ]; then
    echo "Error: Serial port '$PORT' is not a valid character device." >&2
    echo "Tip: Run '$0 --list' or hold BOOT/PRG while plugging in USB-C to enter ESP32 bootloader mode." >&2
    exit 1
fi

ensure_esptool

if [ "$ERASE" = true ]; then
    echo "Erasing full flash on $PORT..."
    python3 -m esptool --port "$PORT" erase_flash
fi

BASE_FW="$(basename "$FIRMWARE")"
OFFSET="0x10000"
if [[ "$BASE_FW" == *-merged.bin || "$BASE_FW" == *.factory.bin || "$BASE_FW" == *factory* ]]; then
    OFFSET="0x00000"
fi

echo "Flashing $BASE_FW to $PORT at offset $OFFSET..."
python3 -m esptool --port "$PORT" --baud 921600 write_flash "$OFFSET" "$FIRMWARE"
echo "========================================================"
echo "✅ Flash complete! Tap RST or power-cycle the node."
echo "========================================================"
