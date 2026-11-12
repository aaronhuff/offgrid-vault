#!/usr/bin/env bash
# ==============================================================================
# download-morale-pack.sh - Low-Power Offline Entertainment Pack
# Curates lightweight, universally playable media (MP4 & MP3) for phones,
# iPads, and laptops to keep morale high without draining batteries.
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MORALE_DIR="$VAULT_DIR/04_MORALE"
mkdir -p "$MORALE_DIR"/{cartoons,radio_dramas,music}

fetch() {
    local url="$1"
    local dest="$2"
    echo "--> Downloading: $(basename "$dest")"
    curl -L --retry 3 -C - -o "$dest" "$url" || {
        echo "Warning: Could not fetch $url. Skipping..."
    }
}

echo "=== 1. Classic Animated Shorts (Universally Playable MP4 / ~40MB each) ==="
# Fleischer Studios Superman: The Mad Scientist (1941 - Public Domain: 45MB)
fetch "https://archive.org/download/superman_1941/superman_1941_512kb.mp4" \
      "$MORALE_DIR/cartoons/Superman_1941_The_Mad_Scientist.mp4"

# Popeye the Sailor: Meets Sindbad the Sailor (1936 Technicolor Classic: ~60MB)
fetch "https://archive.org/download/Popeye_Meets_Sindbad_the_Sailor_1936/Popeye_Meets_Sindbad_the_Sailor_1936_512kb.mp4" \
      "$MORALE_DIR/cartoons/Popeye_Meets_Sindbad_1936.mp4"

echo "=== 2. Screen-Off Audio Dramas (Old Time Radio / Ultra Low Power MP3) ==="
# Sherlock Holmes: The Adventure of the Blue Carbuncle (Orson Welles / John Gielgud: ~15MB)
fetch "https://archive.org/download/OTRR_Sherlock_Holmes_Singles/Sherlock_Holmes_1955-01-02_ep14_The_Blue_Carbuncle.mp3" \
      "$MORALE_DIR/radio_dramas/Sherlock_Holmes_Blue_Carbuncle.mp3"

# The Shadow: The Circle of Death (Orson Welles classic radio thriller: ~12MB)
fetch "https://archive.org/download/TheShadow1930s/1938-03-27-The-Circle-of-Death.mp3" \
      "$MORALE_DIR/radio_dramas/The_Shadow_Circle_of_Death.mp3"

echo "--------------------------------------------------------"
echo "Morale pack downloaded into: $MORALE_DIR"
ls -lh "$MORALE_DIR/cartoons" "$MORALE_DIR/radio_dramas"
