#!/usr/bin/env bash
# ==============================================================================
# package-civilian-pack.sh - Assemble the Civilian Air-Gap Distribution Kit
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SEED_PACK="$VAULT_DIR/00_CIVILIAN_SEED_PACK"

echo "=== Assembling Civilian Seed Pack ==="

# 1. iPhone ePubs & Docs (Ready for AirDrop or USB-C Lightning)
mkdir -p "$SEED_PACK/01_FOR_IPHONE_USERS"
cp -v "$VAULT_DIR/01_KNOWLEDGE/kindle_books/LigiSurvivalManual.epub" "$SEED_PACK/01_FOR_IPHONE_USERS/US_Army_Survival_Manual.epub" 2>/dev/null || true
cp -v "$VAULT_DIR/01_KNOWLEDGE/kindle_books/First_Aid_in_Illness_and_Injury.epub" "$SEED_PACK/01_FOR_IPHONE_USERS/First_Aid_Manual.epub" 2>/dev/null || true
cp -v "$VAULT_DIR/01_KNOWLEDGE/kindle_books/Shelters_Shacks_and_Shanties_Beard.epub" "$SEED_PACK/01_FOR_IPHONE_USERS/Shelter_Construction_Guide.epub" 2>/dev/null || true
cp -v "$VAULT_DIR/02_ENGINEERING/radio_chirp/standard_emergency_frequencies.csv" "$SEED_PACK/01_FOR_IPHONE_USERS/Emergency_Radio_Frequencies.csv" 2>/dev/null || true

# 2. Android APKs & Knowledge (Ready for USB-C OTG)
mkdir -p "$SEED_PACK/02_FOR_ANDROID_USERS/INSTALL_THESE_APKS"
mkdir -p "$SEED_PACK/02_FOR_ANDROID_USERS/KNOWLEDGE_FILES"
cp -v "$VAULT_DIR/00_BOOTSTRAP/apks/organic-maps.apk" "$SEED_PACK/02_FOR_ANDROID_USERS/INSTALL_THESE_APKS/" 2>/dev/null || true
cp -v "$VAULT_DIR/00_BOOTSTRAP/apks/kiwix-android.apk" "$SEED_PACK/02_FOR_ANDROID_USERS/INSTALL_THESE_APKS/" 2>/dev/null || true
cp -v "$VAULT_DIR/00_BOOTSTRAP/apks/meshtastic.apk" "$SEED_PACK/02_FOR_ANDROID_USERS/INSTALL_THESE_APKS/" 2>/dev/null || true

# Copy ePubs to Android knowledge too
cp -v "$SEED_PACK/01_FOR_IPHONE_USERS"/* "$SEED_PACK/02_FOR_ANDROID_USERS/KNOWLEDGE_FILES/" 2>/dev/null || true

echo "--------------------------------------------------------"
echo "Civilian Seed Pack successfully assembled in:"
echo "  $SEED_PACK"
ls -lh "$SEED_PACK"
