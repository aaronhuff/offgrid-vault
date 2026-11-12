#!/usr/bin/env bash
# ==============================================================================
# download-music-pack.sh - Download and convert timeless public domain music
# Ultra low-power MP3s for stress relief, focus, and battery conservation.
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MUSIC_DIR="$VAULT_DIR/04_MORALE/music"
mkdir -p "$MUSIC_DIR"

convert_track() {
    local url="$1"
    local filename="$2"
    echo "--> Downloading & converting: $filename"
    curl -sL -A "Mozilla/5.0" "$url" -o "/tmp/track.ogg"
    ffmpeg -y -i "/tmp/track.ogg" -q:a 2 "$MUSIC_DIR/$filename" 2>/dev/null || {
        echo "Warning: ffmpeg conversion failed for $filename"
    }
    rm -f "/tmp/track.ogg"
}

echo "=== Downloading Public Domain Classical Audio Suite ==="

convert_track "https://upload.wikimedia.org/wikipedia/commons/d/d0/Moonlight_Sonata.ogg" \
              "Beethoven_Moonlight_Sonata.mp3"

convert_track "https://upload.wikimedia.org/wikipedia/commons/b/be/Clair_de_lune_%28Claude_Debussy%29_Suite_bergamasque.ogg" \
              "Debussy_Clair_de_Lune.mp3"

convert_track "https://upload.wikimedia.org/wikipedia/commons/9/9d/Bach_-_Cello_Suite_no._1_in_G_major%2C_BWV_1007_-_I._Pr%C3%A9lude.ogg" \
              "Bach_Cello_Suite_No1_Prelude.mp3"

echo "--------------------------------------------------------"
echo "Music library ready in: $MUSIC_DIR"
ls -lh "$MUSIC_DIR"
