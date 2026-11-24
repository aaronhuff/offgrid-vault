#!/usr/bin/env bash
# ==============================================================================
# download-maps.sh - Offline Organic Maps (.mwm) Regional Pack Downloader
# Downloads base world maps + Ontario & Metro Detroit maps matching APK v260928
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAP_VER="${MAP_VER:-260928}"
DEST_DIR="$VAULT_DIR/01_KNOWLEDGE/maps_mwm/$MAP_VER"
APK_PATH="$VAULT_DIR/00_BOOTSTRAP/apks/organic-maps.apk"

mkdir -p "$DEST_DIR"

MIRRORS=(
    "https://cdn-us3.organicmaps.app/maps/${MAP_VER}"
    "https://cdn-fi1.organicmaps.app/maps/${MAP_VER}"
    "https://cdn-de1.organicmaps.app/maps/${MAP_VER}"
    "https://cdn.organicmaps.app/maps/${MAP_VER}"
)

MAPS=(
    "World.mwm"
    "WorldCoasts.mwm"
    "Canada_Ontario_London.mwm"
    "Canada_Ontario_Toronto.mwm"
    "Canada_Ontario_Bame.mwm"
    "Canada_Ontario_Kingston.mwm"
    "US_Michigan_Detroit.mwm"
)

fetch_mwm() {
    local filename="$1"
    local dest="$DEST_DIR/$filename"
    local part="${dest}.part"

    if [ -f "$dest" ] && [ -s "$dest" ]; then
        echo "Already exists: $filename ($(du -sh "$dest" | cut -f1)) — skipping."
        return 0
    fi

    echo "========================================================"
    echo "Fetching: $filename (version $MAP_VER)"
    echo "========================================================"

    for base_url in "${MIRRORS[@]}"; do
        local url="${base_url}/${filename}"
        echo "Trying mirror: $url"
        if curl -fL --retry 5 --connect-timeout 15 -C - -o "$part" "$url"; then
            mv -f "$part" "$dest"
            echo "Downloaded: $filename ($(du -sh "$dest" | cut -f1))"
            return 0
        fi
        echo "Mirror failed ($base_url), trying next..."
    done

    echo "ERROR: All mirrors failed for $filename (version $MAP_VER)." >&2
    return 1
}

echo "=== Downloading Organic Maps ($MAP_VER) Offline Packs ==="
echo "Target Directory: $DEST_DIR"
echo "--------------------------------------------------------"

for mwm in "${MAPS[@]}"; do
    fetch_mwm "$mwm"
done

# Extract matching countries.txt index from the cached APK
if [ -f "$APK_PATH" ]; then
    echo "--------------------------------------------------------"
    echo "Extracting region index (countries.txt) from organic-maps.apk..."
    if command -v unzip &>/dev/null; then
        unzip -p "$APK_PATH" assets/countries.json > "$DEST_DIR/countries.txt"
    elif command -v python3 &>/dev/null; then
        python3 -c 'import sys, zipfile; z=zipfile.ZipFile(sys.argv[1]); sys.stdout.buffer.write(z.read("assets/countries.json"))' "$APK_PATH" > "$DEST_DIR/countries.txt"
    fi
fi

# Link/reflink maps into Organic Maps Desktop Flatpak data directory if installed
DESKTOP_DATA_DIR="$HOME/.var/app/app.organicmaps.desktop/data/OrganicMaps"
if [ -d "$HOME/.var/app/app.organicmaps.desktop" ] || command -v flatpak &>/dev/null; then
    echo "--------------------------------------------------------"
    echo "Syncing offline maps into Organic Maps Desktop ($DESKTOP_DATA_DIR)..."
    for target_ver in "$MAP_VER" "261110"; do
        mkdir -p "${DESKTOP_DATA_DIR}/${target_ver}"
        cp --reflink=auto -u "$DEST_DIR"/*.mwm "${DESKTOP_DATA_DIR}/${target_ver}/"
    done
fi

echo "========================================================"
echo "Organic Maps offline pack download complete!"
ls -lh "$DEST_DIR"
echo "========================================================"
