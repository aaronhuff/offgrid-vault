#!/usr/bin/env bash
# ==============================================================================
# download-core.sh - Curate and download offline packages, APKs, ZIMs, and models
# ==============================================================================
set -euo pipefail

VAULT_DIR="/var/home/aaronhuff/offgrid-vault"
mkdir -p "$VAULT_DIR"/{00_BOOTSTRAP/{apks,appimages,tools},01_KNOWLEDGE/{zim,manuals_pdf,kindle_books},02_ENGINEERING/{arduino,datasheets,radio_chirp,git_repos},03_INTELLIGENCE/{models_3b,models_7b}}

fetch() {
    local url="$1"
    local dest="$2"
    echo "--> Downloading: $(basename "$dest")"
    curl -L --fail --retry 3 -C - -o "$dest" "$url" || {
        echo "Warning: Failed to fetch $url. Skipping..."
    }
}

echo "=== 1. Downloading Essential Android APKs ==="
# Kiwix Android APK (Offline Wikipedia reader)
fetch "https://download.kiwix.org/release/kiwix-android/kiwix-3.11.2.apk" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/kiwix-android.apk"

# Meshtastic Android APK (For T1000 and C6L off-grid mesh text/GPS)
fetch "https://github.com/meshtastic/Meshtastic-Android/releases/download/2.5.8/app-fdroid-release.apk" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/meshtastic.apk"

# Organic Maps APK (Full offline GPS mapping & terrain)
fetch "https://github.com/organicmaps/organicmaps/releases/download/2024.10.15-5-android/OrganicMaps-24101505-fdroid.apk" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/organic-maps.apk"

echo "=== 2. Downloading Standalone Linux AppImages & Tools ==="
# Kiwix Desktop AppImage (For Laptop & Pi 500)
fetch "https://download.kiwix.org/release/kiwix-desktop/kiwix-desktop_x86_64.AppImage" \
      "$VAULT_DIR/00_BOOTSTRAP/appimages/kiwix-desktop.AppImage"
chmod +x "$VAULT_DIR/00_BOOTSTRAP/appimages/kiwix-desktop.AppImage" 2>/dev/null || true

# Arduino CLI static binary (Lightweight CLI for flashing Cardputer, M5Stack, Arduino without GUI)
fetch "https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_64bit.tar.gz" \
      "$VAULT_DIR/00_BOOTSTRAP/tools/arduino-cli_latest_Linux_64bit.tar.gz"

echo "=== 3. Downloading High-Value Kiwix ZIM Knowledge Archives ==="
# WikiMed: Offline Medical Encyclopedia (~2.5GB)
fetch "https://download.kiwix.org/zim/wikipedia/wikipedia_en_medicine_maxi_2024-05.zim" \
      "$VAULT_DIR/01_KNOWLEDGE/zim/wikipedia_en_medicine_maxi.zim"

# WikiHow: Practical DIY, repair, first-aid, survival guides (~8GB)
fetch "https://download.kiwix.org/zim/wikihow/wikihow_en_maxi_2024-05.zim" \
      "$VAULT_DIR/01_KNOWLEDGE/zim/wikihow_en_maxi.zim"

# iFixit: Electronics, automotive, appliance repair (~3.5GB)
fetch "https://download.kiwix.org/zim/other/ifixit_en_all_2024-05.zim" \
      "$VAULT_DIR/01_KNOWLEDGE/zim/ifixit_en_all.zim"

echo "=== 4. Downloading Local LLM Models (GGUF Quantized) ==="
# Llama-3.2-1B-Instruct (Pocket Phone size: ~750MB, runs smoothly on mobile CPUs/NPUs)
fetch "https://huggingface.co/bartowski/Llama-3.2-1B-Instruct-GGUF/resolve/main/Llama-3.2-1B-Instruct-Q4_K_M.gguf" \
      "$VAULT_DIR/03_INTELLIGENCE/models_3b/Llama-3.2-1B-Instruct-Q4_K_M.gguf"

# Llama-3.2-3B-Instruct (Low power, fast CPU inference, fits on 32GB card if desired: ~2.0GB)
fetch "https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf" \
      "$VAULT_DIR/03_INTELLIGENCE/models_3b/Llama-3.2-3B-Instruct-Q4_K_M.gguf"

# Qwen2.5-Coder-7B-Instruct (Primary engineering/coding intelligence: ~4.5GB)
fetch "https://huggingface.co/bartowski/Qwen2.5-Coder-7B-Instruct-GGUF/resolve/main/Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf" \
      "$VAULT_DIR/03_INTELLIGENCE/models_7b/Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf"

echo "=== 5. Caching Critical Python Wheels (Offline PyPI) ==="
if command -v pip &>/dev/null; then
    echo "Downloading wheels for esptool, pyserial, meshtastic, cryptography, rich..."
    pip download -d "$VAULT_DIR/02_ENGINEERING/python_wheels" \
        pyserial esptool meshtastic cryptography rich click pydantic httpx || true
fi

echo "=== Download manifest execution complete! ==="
