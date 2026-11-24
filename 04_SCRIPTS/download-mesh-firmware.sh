#!/usr/bin/env bash
# ==============================================================================
# download-mesh-firmware.sh - Offline MeshCore & Meshtastic Firmware Downloader
# Caches ready-to-flash MeshCore (Room Server, Repeater, Companion) and
# Meshtastic (ESP32-S3, ESP32-C6, nRF52840) images for air-gapped field use.
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LORA_DIR="$VAULT_DIR/02_ENGINEERING/lora_mesh"
MC_DIR="$LORA_DIR/meshcore"
MT_DIR="$LORA_DIR/meshtastic"
MT_EXTRACT_DIR="$MT_DIR/extracted"

MC_VER="${MC_VER:-v1.18.0}"
MC_SHA="${MC_SHA:-81dbae5}"
MT_VER="${MT_VER:-2.7.26.54e0d8d}"

mkdir -p "$MC_DIR" "$MT_DIR" "$MT_EXTRACT_DIR"

fetch() {
    local url="$1"
    local dest="$2"
    local part="${dest}.part"

    if [ -f "$dest" ] && [ -s "$dest" ]; then
        echo "Already exists: $(basename "$dest") ($(du -sh "$dest" | cut -f1)) — skipping."
        return 0
    fi

    echo "========================================================"
    echo "Fetching: $(basename "$dest")"
    echo "From    : $url"
    echo "========================================================"
    curl -fL --retry 5 --connect-timeout 15 -C - -o "$part" "$url"
    mv -f "$part" "$dest"
    echo "Saved   : $(basename "$dest") ($(du -sh "$dest" | cut -f1))"
}

echo "=== 1. Downloading MeshCore (${MC_VER}) Firmwares ==="
MC_BASE="https://github.com/meshcore-dev/MeshCore/releases/download"

# Heltec WiFi LoRa 32 V4 (ESP32-S3 + SX1262 + PA — Room Server, Repeater, Companion)
fetch "${MC_BASE}/room-server-${MC_VER}/heltec_v4_room_server-${MC_VER}-${MC_SHA}-merged.bin" \
      "$MC_DIR/heltec_v4_room_server-${MC_VER}-${MC_SHA}-merged.bin"
fetch "${MC_BASE}/repeater-${MC_VER}/heltec_v4_repeater-${MC_VER}-${MC_SHA}-merged.bin" \
      "$MC_DIR/heltec_v4_repeater-${MC_VER}-${MC_SHA}-merged.bin"
fetch "${MC_BASE}/companion-${MC_VER}/heltec_v4_companion_radio_ble-${MC_VER}-${MC_SHA}-merged.bin" \
      "$MC_DIR/heltec_v4_companion_radio_ble-${MC_VER}-${MC_SHA}-merged.bin"
fetch "${MC_BASE}/companion-${MC_VER}/heltec_v4_companion_radio_usb-${MC_VER}-${MC_SHA}-merged.bin" \
      "$MC_DIR/heltec_v4_companion_radio_usb-${MC_VER}-${MC_SHA}-merged.bin"

# Heltec WiFi LoRa 32 V3 (ESP32-S3)
fetch "${MC_BASE}/room-server-${MC_VER}/Heltec_v3_room_server-${MC_VER}-${MC_SHA}-merged.bin" \
      "$MC_DIR/Heltec_v3_room_server-${MC_VER}-${MC_SHA}-merged.bin"
fetch "${MC_BASE}/repeater-${MC_VER}/Heltec_v3_repeater-${MC_VER}-${MC_SHA}-merged.bin" \
      "$MC_DIR/Heltec_v3_repeater-${MC_VER}-${MC_SHA}-merged.bin"
fetch "${MC_BASE}/companion-${MC_VER}/Heltec_v3_companion_radio_ble-${MC_VER}-${MC_SHA}-merged.bin" \
      "$MC_DIR/Heltec_v3_companion_radio_ble-${MC_VER}-${MC_SHA}-merged.bin"
fetch "${MC_BASE}/companion-${MC_VER}/Heltec_v3_companion_radio_usb-${MC_VER}-${MC_SHA}-merged.bin" \
      "$MC_DIR/Heltec_v3_companion_radio_usb-${MC_VER}-${MC_SHA}-merged.bin"

# Seeed SenseCAP T1000-E (nRF52840 UF2)
fetch "${MC_BASE}/room-server-${MC_VER}/t1000e_room_server-${MC_VER}-${MC_SHA}.uf2" \
      "$MC_DIR/t1000e_room_server-${MC_VER}-${MC_SHA}.uf2"
fetch "${MC_BASE}/repeater-${MC_VER}/t1000e_repeater-${MC_VER}-${MC_SHA}.uf2" \
      "$MC_DIR/t1000e_repeater-${MC_VER}-${MC_SHA}.uf2"
fetch "${MC_BASE}/companion-${MC_VER}/t1000e_companion_radio_ble-${MC_VER}-${MC_SHA}.uf2" \
      "$MC_DIR/t1000e_companion_radio_ble-${MC_VER}-${MC_SHA}.uf2"
fetch "${MC_BASE}/companion-${MC_VER}/t1000e_companion_radio_usb-${MC_VER}-${MC_SHA}.uf2" \
      "$MC_DIR/t1000e_companion_radio_usb-${MC_VER}-${MC_SHA}.uf2"

# RAK4631 WisBlock (nRF52840 UF2)
fetch "${MC_BASE}/room-server-${MC_VER}/RAK_4631_room_server-${MC_VER}-${MC_SHA}.uf2" \
      "$MC_DIR/RAK_4631_room_server-${MC_VER}-${MC_SHA}.uf2"
fetch "${MC_BASE}/repeater-${MC_VER}/RAK_4631_repeater-${MC_VER}-${MC_SHA}.uf2" \
      "$MC_DIR/RAK_4631_repeater-${MC_VER}-${MC_SHA}.uf2"
fetch "${MC_BASE}/companion-${MC_VER}/RAK_4631_companion_radio_ble-${MC_VER}-${MC_SHA}.uf2" \
      "$MC_DIR/RAK_4631_companion_radio_ble-${MC_VER}-${MC_SHA}.uf2"
fetch "${MC_BASE}/companion-${MC_VER}/RAK_4631_companion_radio_usb-${MC_VER}-${MC_SHA}.uf2" \
      "$MC_DIR/RAK_4631_companion_radio_usb-${MC_VER}-${MC_SHA}.uf2"

echo "=== 2. Downloading Meshtastic (v${MT_VER}) Release Bundles ==="
MT_BASE="https://github.com/meshtastic/firmware/releases/download/v${MT_VER}"

fetch "${MT_BASE}/firmware-esp32s3-${MT_VER}.zip" \
      "$MT_DIR/firmware-esp32s3-${MT_VER}.zip"
fetch "${MT_BASE}/firmware-esp32c6-${MT_VER}.zip" \
      "$MT_DIR/firmware-esp32c6-${MT_VER}.zip"
fetch "${MT_BASE}/firmware-nrf52840-${MT_VER}.zip" \
      "$MT_DIR/firmware-nrf52840-${MT_VER}.zip"

echo "=== 3. Extracting Priority Meshtastic Images ==="
python3 - "$MT_DIR" "$MT_EXTRACT_DIR" << 'PYEOF'
import os, sys, zipfile

mt_dir, out_dir = sys.argv[1], sys.argv[2]
needles = ("heltec-v4", "heltec_v4", "heltec-v3", "heltec_v3", "t1000-e", "t1000_e", "unitc6l", "rak4631", "bleota", "littlefs")

extracted = 0
for fname in sorted(os.listdir(mt_dir)):
    if not fname.endswith(".zip"):
        continue
    zpath = os.path.join(mt_dir, fname)
    with zipfile.ZipFile(zpath) as zf:
        for member in zf.namelist():
            base = os.path.basename(member)
            if not base:
                continue
            low = base.lower()
            if any(n in low for n in needles) and low.endswith((".bin", ".uf2")):
                target = os.path.join(out_dir, base)
                with zf.open(member) as src, open(target, "wb") as dst:
                    dst.write(src.read())
                extracted += 1
                print(f"  Extracted: {base}")

print(f"Total extracted images: {extracted}")
PYEOF

echo "========================================================"
echo "MeshCore & Meshtastic firmware cache complete!"
echo "MeshCore  : $MC_DIR ($(du -sh "$MC_DIR" | cut -f1))"
echo "Meshtastic: $MT_DIR ($(du -sh "$MT_DIR" | cut -f1))"
echo "========================================================"
