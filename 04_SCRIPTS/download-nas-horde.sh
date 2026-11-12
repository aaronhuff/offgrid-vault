#!/usr/bin/env bash
# ==============================================================================
# download-nas-horde.sh - The Deep Archive "Data Horde" Downloader
# Designed for storage directly on Synology NAS (/volume1/nfs/cold-vault/05_NAS_HORDE)
# ==============================================================================
set -euo pipefail

DEST_DIR="${1:-/volume1/nfs/cold-vault/05_NAS_HORDE}"
mkdir -p "$DEST_DIR"/{isos/{rescue,linux,hypervisor,sbc},knowledge_maxi,firmware_drivers}

fetch() {
    local url="$1"
    local dest="$2"
    if [ -f "$dest" ] && [ -s "$dest" ]; then
        echo "========================================================"
        echo "Already exists: $(basename "$dest") ($(du -sh "$dest" | cut -f1))"
        echo "Skipping download."
        echo "========================================================"
        return 0
    fi
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
fetch "https://downloads.sourceforge.net/project/systemrescuecd/sysresccd-x86/11.02/systemrescue-11.02-amd64.iso" \
      "$DEST_DIR/isos/rescue/systemrescue-11.02-amd64.iso"

# Clonezilla Live: Offline disk/partition bare-metal cloning (~400MB)
fetch "https://downloads.sourceforge.net/project/clonezilla/clonezilla_live_stable/3.1.3-11/clonezilla-live-3.1.3-11-amd64.iso" \
      "$DEST_DIR/isos/rescue/clonezilla-live-amd64.iso"

echo "=== 2. Universal OS Installation ISOs ==="
# Debian 13 (Trixie) Full DVD-1 (~3.7GB - COMPLETE OFFLINE APT REPOSITORY)
fetch "https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-13.7.0-amd64-DVD-1.iso" \
      "$DEST_DIR/isos/linux/debian-13-DVD-1-amd64.iso"

# Debian 13 (Trixie) Netinst (~600MB - Minimal fallback)
fetch "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.7.0-amd64-netinst.iso" \
      "$DEST_DIR/isos/linux/debian-13-netinst-amd64.iso"

# Ubuntu 24.04 LTS (Noble Numbat) Server (~2.6GB)
fetch "https://releases.ubuntu.com/24.04/ubuntu-24.04.3-live-server-amd64.iso" \
      "$DEST_DIR/isos/linux/ubuntu-24.04-live-server-amd64.iso"

# Alpine Linux Standard (Ultra-lightweight 200MB rescue/server)
fetch "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-standard-3.20.3-x86_64.iso" \
      "$DEST_DIR/isos/linux/alpine-standard-3.20.3-x86_64.iso"

echo "=== 3. Hypervisor & Infrastructure Rebuild ISOs ==="
# Proxmox VE 9 ISO (To rebuild pve1/pve2 from bare metal: ~1.4GB)
fetch "https://enterprise.proxmox.com/iso/proxmox-ve_9.2-1.iso" \
      "$DEST_DIR/isos/hypervisor/proxmox-ve_9.2-1.iso"

echo "=== 4. Single-Board Computer Images (RPi 500 & RPi 4B) ==="
# Raspberry Pi OS 64-bit Lite (~500MB)
fetch "https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2026-10-06/2026-10-06-raspios-trixie-arm64-lite.img.xz" \
      "$DEST_DIR/isos/sbc/raspios-trixie-arm64-lite.img.xz"

echo "========================================================"
echo "NAS Horde download manifest executed!"
echo "Target directory: $DEST_DIR"
echo "========================================================"
