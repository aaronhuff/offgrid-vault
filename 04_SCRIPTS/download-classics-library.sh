#!/usr/bin/env bash
# ==============================================================================
# download-classics-library.sh - Curated Public Domain Classics for Kindle / e-Reader
# Timeless, royalty-free literature from Project Gutenberg (~10MB total)
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$VAULT_DIR/01_KNOWLEDGE/kindle_books/classics"
mkdir -p "$TARGET_DIR"

fetch_classic() {
    local id="$1"
    local title="$2"
    echo "--> Downloading: $title"
    # Project Gutenberg standard direct ePub URLs
    curl -L --retry 3 -C - \
         "https://www.gutenberg.org/cache/epub/${id}/pg${id}-images-3.epub" \
         -o "$TARGET_DIR/${title}.epub" || {
        # Fallback to no-images variant if images build fails
        curl -L --retry 3 -C - \
             "https://www.gutenberg.org/ebooks/${id}.epub.noimages" \
             -o "$TARGET_DIR/${title}.epub" || {
            echo "Warning: Could not fetch $title. Skipping..."
        }
    }
}

echo "=== Downloading Classic Royalty-Free Literature ==="

# Foundational Literature & Philosophy
fetch_classic "2701"  "Moby_Dick_Herman_Melville"
fetch_classic "2680"  "Meditations_Marcus_Aurelius"
fetch_classic "132"   "The_Art_of_War_Sun_Tzu"
fetch_classic "205"   "Walden_Henry_David_Thoreau"

# Adventure & Exploration
fetch_classic "1184"  "The_Count_of_Monte_Cristo_Dumas"
fetch_classic "120"   "Treasure_Island_Stevenson"
fetch_classic "521"   "Robinson_Crusoe_Defoe"
fetch_classic "164"   "Twenty_Thousand_Leagues_Under_the_Sea_Verne"

# Mystery & Speculative Fiction
fetch_classic "1661"  "Adventures_of_Sherlock_Holmes_Conan_Doyle"
fetch_classic "84"    "Frankenstein_Mary_Shelley"
fetch_classic "35"    "The_Time_Machine_HG_Wells"
fetch_classic "345"   "Dracula_Bram_Stoker"

echo "--------------------------------------------------------"
echo "Classics library successfully downloaded to: $TARGET_DIR"
ls -lh "$TARGET_DIR"
