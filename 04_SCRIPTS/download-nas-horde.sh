#!/usr/bin/env bash
# ==============================================================================
# download-nas-horde.sh - The Deep Archive "Data Horde" Downloader
# Designed for storage on high-capacity media or Synology NAS (/volume1/...)
# ==============================================================================
set -euo pipefail

DEST_DIR="${1:-/var/home/aaronhuff/repos/offgrid-vault/05_NAS_HORDE}"
mkdir -p "$DEST_DIR"/{isos/{rescue,linux,hypervisor,sbc},knowledge_maxi,firmware_drivers}

fetch() {
    local url="$1"
    local dest="$2"
    echo "========================================================"
    echo "Fetching: $(basename "$dest")"
    echo "From    : $url"
    echo "========================================================"
    curl -L --retry 5 -C - -o "$dest" "$url" || {
        echo "Warning: Download of $url failed or interrupted. Run again to resume."
    }
}

echo "=== 1. Core Rescue & Recovery ISOs ==="
# SystemRescue: The ultimate Linux partition & disk recovery toolkit (~900MB)
fetch "https://osdn.dl.osdn.net/systemrescuecd/systemrescue-11.02-amd64.iso" \
      "$DEST_DIR/isos/rescue/systemrescue-11.02-amd64.iso"

# Clonezilla Live: Offline disk/partition bare-metal cloning (~400MB)
fetch "https://downloads.sourceforge.net/project/clonezilla/clonezilla_live_stable/3.1.3-11/clonezilla-live-3.1.3-11-amd64.iso" \
      "$DEST_DIR/isos/rescue/clonezilla-live-amd64.iso"

echo "=== 2. Universal OS Installation ISOs ==="
# Debian 12 (Bookworm) Netinst (~600MB)
fetch "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.8.0-amd64-netinst.iso" \
      "$DEST_DIR/isos/linux/debian-12-netinst-amd64.iso"

# Ubuntu 24.04 LTS (Noble Numbat) Server (~2.6GB)
fetch "https://releases.ubuntu.com/24.04/ubuntu-24.04.1-live-server-amd64.iso" \
      "$DEST_DIR/isos/linux/ubuntu-24.04.1-live-server-amd64.iso"

# Alpine Linux Standard (Ultra-lightweight 200MB rescue/server)
fetch "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-standard-3.20.3-x86_64.iso" \
      "$DEST_DIR/isos/linux/alpine-standard-3.20.3-x86_64.iso"

echo "=== 3. Hypervisor & Infrastructure Rebuild ISOs ==="
# Proxmox VE 8 ISO (To rebuild pve1/pve2 from bare metal: ~1.3GB)
fetch "https://enterprise.proxmox.com/iso/proxmox-ve_8.2-1.iso" \
      "$DEST_DIR/isos/hypervisor/proxmox-ve_8.2-1.iso"

echo "=== 4. Single-Board Computer Images (RPi 500 & RPi 4B) ==="
# Raspberry Pi OS 64-bit Lite (For headless recovery of RPi 4B / Pi 5: ~500MB)
fetch "https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2024-10-28/2024-10-22-raspios-bookworm-arm64-lite.img.xz" \
      "$DEST_DIR/isos/sbc/raspios-bookworm-arm64-lite.img.xz"

echo "=== 5. Radio & Hardware Firmware Archives ==="
# Quansheng UV-K5 popular open firmware releases (Egzumer / IJV)
fetch "https://github.com/egzumer/uv-k5-firmware-custom/releases/download/v0.22/k5_v0.22.bin" \
      "$DEST_DIR/firmware_drivers/quansheng_egzumer_v0.22.bin"

echo "========================================================"
echo "NAS Horde download manifest executed!"
echo "Target directory: $DEST_DIR"
echo "========================================================"
