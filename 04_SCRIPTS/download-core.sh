#!/usr/bin/env bash
# ==============================================================================
# download-core.sh - Curate and download offline packages, APKs, ZIMs, and models
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$VAULT_DIR"/{00_BOOTSTRAP/{apks,appimages,tools/windows_portable},01_KNOWLEDGE/{zim,manuals_pdf,kindle_books},02_ENGINEERING/{arduino,datasheets,radio_chirp,git_repos},03_INTELLIGENCE/{models_3b,models_7b}}

fetch() {
    local url="$1"
    local dest="$2"
    echo "--> Downloading: $(basename "$dest")"
    curl -L --fail --retry 3 -C - -o "$dest" "$url" || {
        echo "Warning: Failed to fetch $url. Skipping..."
    }
}

fetch_gh_latest() {
    local repo="$1"
    local pattern="$2"
    local dest="$3"
    local url
    url="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
        | grep -oE '"browser_download_url": *"[^"]+"' \
        | cut -d'"' -f4 \
        | grep -E "$pattern" \
        | head -n1 || true)"
    if [[ -n "$url" ]]; then
        fetch "$url" "$dest"
    else
        echo "Warning: No matching release asset ($pattern) found for $repo. Skipping..."
    fi
}

echo "=== 1. Downloading Essential Android APKs (Universal Offline Kit) ==="
# Kiwix Android APK (Offline Wikipedia / WikiMed / WikiHow reader)
fetch "https://download.kiwix.org/release/kiwix-android/kiwix-3.11.2.apk" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/kiwix-android.apk"

# Meshtastic Android APK (For T1000 and LoRa off-grid mesh text/GPS)
fetch_gh_latest "meshtastic/Meshtastic-Android" "fdroid-release\.apk$" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/meshtastic.apk"

# Organic Maps APK (Full offline GPS mapping & terrain)
fetch_gh_latest "organicmaps/organicmaps" "fdroid\.apk$" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/organic-maps.apk"

# LocalSend APK (Cross-platform Wi-Fi P2P AirDrop for organic file seeding)
fetch_gh_latest "localsend/localsend" "android-arm64.*\.apk$|arm64.*\.apk$|android.*\.apk$" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/localsend.apk"

# Briar APK (Offline BLE + local Wi-Fi mesh messaging & forums)
fetch "https://briarproject.org/apk/briar.apk" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/briar.apk"

# Bitchat APK (Zero-infrastructure BLE mesh chat)
fetch_gh_latest "permissionlesstech/bitchat-android" "universal\.apk$|arm64\.apk$" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/bitchat.apk"

# Librera Reader APK (Offline EPUB/PDF manual reader for phones/tablets)
fetch_gh_latest "foobnix/LibreraReader" "Librera.*\.apk$" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/librera.apk"

# Trail Sense APK (Offline compass, barometer storm alert, solar/lunar, survival tools)
fetch_gh_latest "kylecorry31/Trail-Sense" "\.apk$" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/trail-sense.apk"

# Termux APK (Offline Linux/Python/SSH terminal on Android via OTG)
fetch_gh_latest "termux/termux-app" "universal\.apk$" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/termux.apk"

# KeePassDX APK (Offline password/key vault)
fetch_gh_latest "Kunzisoft/KeePassDX" "libre\.apk$" \
      "$VAULT_DIR/00_BOOTSTRAP/apks/keepassdx.apk"

# VLC for Android APK (Offline media/morale MP3 & MP4 player)
VLC_FILE="$(curl -fsSL "https://get.videolan.org/vlc-android/last/" 2>/dev/null \
    | grep -oE 'VLC-Android-[^"]+arm64-v8a\.apk' | head -n1 || true)"
if [[ -n "$VLC_FILE" ]]; then
    fetch "https://get.videolan.org/vlc-android/last/$VLC_FILE" \
          "$VAULT_DIR/00_BOOTSTRAP/apks/vlc.apk"
else
    echo "Warning: Could not resolve latest VLC Android APK. Skipping..."
fi

echo "=== 2. Downloading Universal Linux AppImages & Static Tools ==="
# AppImages run across Ubuntu, Debian, Fedora, Arch, Mint without package managers
fetch "https://download.kiwix.org/release/kiwix-desktop/kiwix-desktop_x86_64.AppImage" \
      "$VAULT_DIR/00_BOOTSTRAP/appimages/kiwix-desktop.AppImage"

fetch_gh_latest "localsend/localsend" "linux-x86-64\.AppImage$|\.AppImage$" \
      "$VAULT_DIR/00_BOOTSTRAP/appimages/LocalSend-x86_64.AppImage"

fetch_gh_latest "keepassxreboot/keepassxc" "x86_64\.AppImage$" \
      "$VAULT_DIR/00_BOOTSTRAP/appimages/KeePassXC-x86_64.AppImage"

chmod +x "$VAULT_DIR/00_BOOTSTRAP/appimages/"*.AppImage 2>/dev/null || true

# Arduino CLI static binary (Optional engineering: Cardputer, M5Stack, Arduino)
fetch "https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_64bit.tar.gz" \
      "$VAULT_DIR/00_BOOTSTRAP/tools/arduino-cli_latest_Linux_64bit.tar.gz"

echo "=== 3. Downloading Windows Portable Tools (For Salvaged Windows Laptops) ==="
fetch_gh_latest "localsend/localsend" "windows-x86-64\.zip$" \
      "$VAULT_DIR/00_BOOTSTRAP/tools/windows_portable/LocalSend-windows-portable.zip"

fetch "https://download.kiwix.org/release/kiwix-desktop/kiwix-desktop_windows_x64.zip" \
      "$VAULT_DIR/00_BOOTSTRAP/tools/windows_portable/kiwix-desktop_windows_x64.zip"

echo "=== 4. Downloading High-Value Kiwix ZIM Knowledge Archives ==="
# WikiMed: Offline Medical Encyclopedia (~2.5GB)
fetch "https://download.kiwix.org/zim/wikipedia/wikipedia_en_medicine_maxi_2024-05.zim" \
      "$VAULT_DIR/01_KNOWLEDGE/zim/wikipedia_en_medicine_maxi.zim"

# WikiHow: Practical DIY, repair, first-aid, survival guides (~8GB)
fetch "https://download.kiwix.org/zim/wikihow/wikihow_en_maxi_2024-05.zim" \
      "$VAULT_DIR/01_KNOWLEDGE/zim/wikihow_en_maxi.zim"

# iFixit: Electronics, automotive, appliance repair (~3.5GB)
fetch "https://download.kiwix.org/zim/other/ifixit_en_all_2024-05.zim" \
      "$VAULT_DIR/01_KNOWLEDGE/zim/ifixit_en_all.zim"

echo "=== 5. Downloading Local LLM Models (GGUF Quantized) ==="
# Llama-3.2-1B-Instruct (Pocket Phone size: ~750MB, runs smoothly on mobile CPUs/NPUs)
fetch "https://huggingface.co/bartowski/Llama-3.2-1B-Instruct-GGUF/resolve/main/Llama-3.2-1B-Instruct-Q4_K_M.gguf" \
      "$VAULT_DIR/03_INTELLIGENCE/models_3b/Llama-3.2-1B-Instruct-Q4_K_M.gguf"

# Llama-3.2-3B-Instruct (Low power, fast CPU inference, fits on 32GB card if desired: ~2.0GB)
fetch "https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf" \
      "$VAULT_DIR/03_INTELLIGENCE/models_3b/Llama-3.2-3B-Instruct-Q4_K_M.gguf"

# Qwen2.5-Coder-7B-Instruct (Primary engineering/coding intelligence: ~4.5GB)
fetch "https://huggingface.co/bartowski/Qwen2.5-Coder-7B-Instruct-GGUF/resolve/main/Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf" \
      "$VAULT_DIR/03_INTELLIGENCE/models_7b/Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf"

echo "=== 6. Caching Critical Python Wheels (Offline PyPI) ==="
if command -v pip &>/dev/null; then
    echo "Downloading wheels for esptool, pyserial, meshtastic, cryptography, rich..."
    pip download -d "$VAULT_DIR/02_ENGINEERING/python_wheels" \
        pyserial esptool meshtastic cryptography rich click pydantic httpx || true
fi

echo "=== Download manifest execution complete! ==="
