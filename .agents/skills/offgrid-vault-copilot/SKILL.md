---
name: offgrid-vault-copilot
description: Operational guidance for local LLMs and AI coding agents on how to navigate, query, compile, and flash hardware using the offline resources in offgrid-vault.
---

# Off-Grid Vault Copilot

This skill guides local AI models (such as `qwen2.5-coder:7b` or `llama3.2:3b`) and coding agents (OpenCode, Continue, Cline, Roo-Code) on how to operate strictly offline within this repository.

## Golden Rules for Offline Operation

1. **Zero Internet Assumption**: Never attempt `pip install <package>`, `npm install`, `curl <web_url>`, or online documentation queries. Everything you need is already cached on disk.
2. **Low Power Consciousness**: Generate concise, clean code. Do not suggest heavyweight frameworks when a minimal C/C++ or standard-library Python script suffices.
3. **Reference Local Paths**: Always use relative paths starting from the repository root.

---

## Resource Directory & Cheat Sheet

### 1. Embedded Hardware & Arduino Compilation (`02_ENGINEERING/arduino/`)
- **Binary**: `02_ENGINEERING/arduino/arduino-cli`
- **Config**: `02_ENGINEERING/arduino/arduino-cli.yaml`
- **Cached Cores**:
  - `esp32:esp32` (Supports ESP32-S3, M5Stack Cardputer, M5Stack CoreS3, ESP CYD)
  - `arduino:avr` (Supports Arduino Uno, Nano, Mega)
- **Cached Libraries**: `M5Unified`, `M5GFX`, `M5Cardputer`, `IRremote`, `LibSSH-ESP32`

#### Compile & Flash Commands:
```bash
# Compile a sketch for M5Stack Cardputer:
./02_ENGINEERING/arduino/arduino-cli compile \
  --config-file ./02_ENGINEERING/arduino/arduino-cli.yaml \
  --fqbn esp32:esp32:m5stack_cardputer \
  path/to/sketch

# Flash sketch to connected USB serial device:
./02_ENGINEERING/arduino/arduino-cli upload \
  --config-file ./02_ENGINEERING/arduino/arduino-cli.yaml \
  --fqbn esp32:esp32:m5stack_cardputer \
  -p /dev/ttyACM0 \
  path/to/sketch
```

---

### 2. Offline Python Wheelhouse (`02_ENGINEERING/python_wheels/`)
- Contains 35 pre-cached wheel files (`pyserial`, `esptool`, `meshtastic`, `cryptography`, `rich`, `click`, `pydantic`, `httpx`, `bleak`).
- **Install command**:
  ```bash
  python3 -m pip install --no-index --find-links=./02_ENGINEERING/python_wheels/ <package_name>
  ```
- **Direct Serial Telemetry**: Use `pyserial` to interface with Cardputer, GPS, or microcontrollers.
- **Microcontroller Recovery**: Use `esptool.py` to dump or flash raw ESP32 binaries.

---

### 3. Tactical RF & Radios (`02_ENGINEERING/radio_chirp/`)
- Channel presets file: `02_ENGINEERING/radio_chirp/standard_emergency_frequencies.csv`
- Contains exact simplex calling frequencies:
  - 2m FM Calling: `146.520 MHz`
  - 70cm FM Calling: `446.000 MHz`
  - NOAA Weather Channels: `WX1 (162.550)` through `WX7 (162.525)`
  - MURS Channels: `151.820` to `154.600 MHz`
  - FRS / GMRS: Channels 1 through 22

---

### 4. Multimodal Vision Querying (`127.0.0.1:11434`)
- Model: `moondream` (Local Ollama vision model)
- Usage for diagnosing photos of electronics, rashes, or plants:
  ```bash
  podman exec -it offgrid-ollama ollama run moondream "Explain what circuit component this is and its pinout" /path/to/image.jpg
  ```

---

### 5. Media Synchronization (`04_SCRIPTS/`)
- **Pocket Survival (32GB MicroSD)**: `./04_SCRIPTS/sync-vault.sh --profile sd32 --target /media/SD_CARD`
- **Workstation Flash (128GB USB)**: `./04_SCRIPTS/sync-vault.sh --profile usb128 --target /media/USB_DRIVE`
- **Synology NAS Mirror (10.1.1.2)**: `./04_SCRIPTS/sync-nas.sh`
