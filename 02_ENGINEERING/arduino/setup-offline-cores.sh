#!/usr/bin/env bash
# ==============================================================================
# setup-offline-cores.sh - Download Arduino cores & libraries for offline use
# ==============================================================================
set -euo pipefail

VAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ARDUINO_DIR="$VAULT_DIR/02_ENGINEERING/arduino"
CLI_TAR="$VAULT_DIR/00_BOOTSTRAP/tools/arduino-cli_latest_Linux_64bit.tar.gz"

mkdir -p "$ARDUINO_DIR"/{data,libraries,sketches}

# Unpack arduino-cli if needed
if [[ -f "$CLI_TAR" && ! -f "$ARDUINO_DIR/arduino-cli" ]]; then
    echo "Extracting arduino-cli..."
    tar -xzf "$CLI_TAR" -C "$ARDUINO_DIR" arduino-cli
    chmod +x "$ARDUINO_DIR/arduino-cli"
fi

CLI="$ARDUINO_DIR/arduino-cli"

if [[ ! -x "$CLI" ]]; then
    echo "Error: arduino-cli not found. Run 04_SCRIPTS/download-core.sh first."
    exit 1
fi

echo "Configuring portable arduino-cli environment..."
cat <<EOF > "$ARDUINO_DIR/arduino-cli.yaml"
board_manager:
  additional_urls:
    - https://espressif.github.io/arduino-esp32/package_esp32_index.json
directories:
  data: $ARDUINO_DIR/data
  downloads: $ARDUINO_DIR/downloads
  user: $ARDUINO_DIR
EOF

echo "Updating core indexes..."
"$CLI" core update-index --config-file "$ARDUINO_DIR/arduino-cli.yaml"

echo "Downloading ESP32 core (For Cardputer, M5Stack S3, ESP32)..."
"$CLI" core install esp32:esp32 --config-file "$ARDUINO_DIR/arduino-cli.yaml"

echo "Downloading AVR core (For Arduino Uno, Nano, Mega)..."
"$CLI" core install arduino:avr --config-file "$ARDUINO_DIR/arduino-cli.yaml"

echo "Downloading common libraries (M5Cardputer, M5Unified, FastLED, Wire)..."
"$CLI" lib install "M5Unified" --config-file "$ARDUINO_DIR/arduino-cli.yaml" || true
"$CLI" lib install "M5Cardputer" --config-file "$ARDUINO_DIR/arduino-cli.yaml" || true

echo "========================================================="
echo "Arduino offline environment successfully cached!"
echo "All toolchains and compilers reside in $ARDUINO_DIR/data"
echo "========================================================="
