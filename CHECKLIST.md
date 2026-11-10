# Off-Grid Vault: Implementation & Readiness Checklist

Status: **16.1 GB Total Curated Offline Payload**

---

## 1. Laptop & Mobile Intelligence (`03_INTELLIGENCE/` - 7.0 GB)
- [x] **Laptop Rootless Podman Ollama**: Operational and tested (`offgrid-ollama` on port 11434)
- [x] **`llama3.2:3b` (2.0 GB)**: Verified offline on laptop (~15 tokens/sec)
- [x] **`qwen2.5-coder:7b` (4.7 GB)**: Verified offline on laptop (C++/Arduino coding ready)
- [x] **`Llama-3.2-1B-Instruct-Q4_K_M.gguf` (771 MB)**: Downloaded and ready to drop onto Android/SD card

---

## 2. Tactical & Mobile Software (`00_BOOTSTRAP/` - 610 MB)
- [x] **`kiwix-android.apk` (226 MB)**: Offline Wikipedia / WikiMed reader for Android
- [x] **`meshtastic.apk` (44 MB)**: Off-grid mesh texting & GPS for T1000 & C6L
- [x] **`organic-maps.apk` (61 MB)**: Offline GPS navigation & terrain topography
- [x] **`pocketpal-ai.apk` (264 MB)**: Offline GGUF local model runner for Android
- [x] **`arduino-cli` Linux 64-bit binary (17 MB)**: Lightweight compiler & flasher

---

## 3. Hardware, Radio & Python Toolchains (`02_ENGINEERING/` - 8.3 GB)
- [x] **Offline Python Wheels (14 MB)**: `pyserial`, `esptool`, `meshtastic`, `cryptography`, `rich`, `click`, `pydantic`, `httpx`, `bleak`
- [x] **Cached Arduino ESP32 Core**: Fully installed in `arduino/data/` (for Cardputer & M5Stack S3)
- [x] **Cached Arduino AVR Core**: Fully installed in `arduino/data/` (for Uno, Nano, Mega)
- [x] **Arduino Libraries**: `M5Unified`, `M5GFX`, `M5Cardputer`, `IRremote`, `LibSSH-ESP32`
- [x] **Radio Emergency Frequency Matrix**: `standard_emergency_frequencies.csv` (NOAA 1-7, MURS 1-5, FRS/GMRS 1-22, 2m/70cm calling)

---

## 4. Knowledge & Field Manuals (`01_KNOWLEDGE/` - 191 MB)
- [x] **Survival Manual ePub (4.9 MB)**: `LigiSurvivalManual.epub` formatted for Kindle, iPad, and mobile
- [ ] **WikiMed Maxi ZIM (1.86 GB)**: Resumable archive queued (`04_SCRIPTS/download-core.sh`)
- [ ] **WikiHow Maxi ZIM (~8 GB)**: Queued for large storage profile (`usb128` / `sata`)

---

## 5. Physical Media Stamping & Cold Mirroring (`04_SCRIPTS/`)
- [x] **Vault Sync Script**: `04_SCRIPTS/sync-vault.sh` (with `sd32`, `usb128`, and `sata` profiles)
- [x] **NAS Cold Sync Script**: `04_SCRIPTS/sync-nas.sh` (targeting Synology DS220+ at `10.1.1.2`)
- [ ] **MicroSD Card Stamped**: Plug in 32GB MicroSD and run `./04_SCRIPTS/sync-vault.sh --profile sd32 --target /run/media/USER/CARD`
- [ ] **USB Drive Stamped**: Plug in 128GB USB and run `./04_SCRIPTS/sync-vault.sh --profile usb128 --target /run/media/USER/USB`
- [ ] **NAS Backup Executed**: Run `./04_SCRIPTS/sync-nas.sh`
