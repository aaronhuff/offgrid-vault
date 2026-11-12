#!/usr/bin/env bash
# ==============================================================================
# download-mega-zim.sh - High-Capacity Offline Knowledge ZIM Downloader
# Designed for storage on Synology NAS (/volume1/nfs/cold-vault/05_NAS_HORDE)
# ==============================================================================
set -euo pipefail

DEST_DIR="${1:-/volume1/nfs/cold-vault/05_NAS_HORDE/knowledge_maxi}"
mkdir -p "$DEST_DIR"

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
    curl -L --retry 10 -C - -o "$dest" "$url" || {
        echo "Warning: Download of $url failed or interrupted. Run again to resume."
    }
}

echo "=== 1. High-Priority Survival & Practical Knowledge ZIMs ==="
# WikiMed: Offline Medical & First Aid Encyclopedia with images (~1.7GB)
fetch "https://download.kiwix.org/zim/wikipedia/wikipedia_en_medicine_maxi_2026-10.zim" \
      "$DEST_DIR/wikipedia_en_medicine_maxi_2026-10.zim"

# Appropedia: Off-grid engineering, water, solar, permaculture, disaster tech (~581MB)
fetch "https://download.kiwix.org/zim/other/appropedia_en_all_maxi_2026-02.zim" \
      "$DEST_DIR/appropedia_en_all_maxi_2026-02.zim"

# Wikivoyage: Worldwide geography, city survival maps, navigation (~1.0GB)
fetch "https://download.kiwix.org/zim/wikivoyage/wikivoyage_en_all_maxi_2026-09.zim" \
      "$DEST_DIR/wikivoyage_en_all_maxi_2026-09.zim"

echo "=== 2. The Crown Jewel: Full English Wikipedia ==="
# Full English Wikipedia Maxi: All articles + full image set (~118.6GB)
fetch "https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_maxi_2026-08.zim" \
      "$DEST_DIR/wikipedia_en_all_maxi_2026-08.zim"

echo "========================================================"
echo "Mega-ZIM download complete!"
echo "Target directory: $DEST_DIR"
echo "========================================================"
