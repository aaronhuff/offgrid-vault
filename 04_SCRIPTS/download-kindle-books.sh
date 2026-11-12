#!/usr/bin/env bash
# ==============================================================================
# download-kindle-books.sh - Download curated survival, medical & engineering ePubs
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$VAULT_DIR/01_KNOWLEDGE/kindle_books"
mkdir -p "$TARGET_DIR"

fetch_epub() {
    local url="$1"
    local filename="$2"
    echo "--> Downloading: $filename"
    curl -L --retry 3 -C - -o "$TARGET_DIR/$filename" "$url" || {
        echo "Warning: Could not fetch $filename. Skipping..."
    }
}

echo "=== Curating Kindle ePub Library ==="

# 1. Woodcraft and Camping (Nessmuk - Classic outdoor survival)
fetch_epub "https://www.gutenberg.org/cache/epub/34261/pg34261-images-3.epub" \
           "Woodcraft_and_Camping_Nessmuk.epub"

# 2. Shelters, Shacks, and Shanties (Dan Beard - Practical construction & wilderness shelter)
fetch_epub "https://www.gutenberg.org/cache/epub/41426/pg41426-images-3.epub" \
           "Shelters_Shacks_and_Shanties_Beard.epub"

# 3. The Boy Mechanic: 700 Things for Boys to Do (Practical DIY, mechanics, tools)
fetch_epub "https://www.gutenberg.org/cache/epub/12655/pg12655-images-3.epub" \
           "The_Boy_Mechanic_DIY.epub"

# 4. First Aid in Illness and Injury (Early field medicine & bandages)
fetch_epub "https://www.gutenberg.org/cache/epub/38084/pg38084-images-3.epub" \
           "First_Aid_in_Illness_and_Injury.epub"

# 5. Practical Carpentry (Traditional wood framing, joints, roofing)
fetch_epub "https://www.gutenberg.org/cache/epub/35368/pg35368-images-3.epub" \
           "Practical_Carpentry_Guide.epub"

# 6. Camp Life in the Woods and the Tricks of Trapping (Gibson - Foraging, preserving)
fetch_epub "https://www.gutenberg.org/cache/epub/17093/pg17093-images-3.epub" \
           "Camp_Life_and_Tricks_of_Trapping.epub"

echo "--------------------------------------------------------"
echo "Kindle library updated!"
ls -lh "$TARGET_DIR"
