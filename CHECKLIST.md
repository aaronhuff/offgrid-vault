# Off-Grid Vault: Implementation & Readiness Checklist

Status: **16.1 GB Total Curated Offline Payload**

---

## 1. Laptop & Mobile Intelligence (`03_INTELLIGENCE/` - ~7.1 GB)
- [x] **Laptop Rootless Podman Ollama**: Operational and tested (`offgrid-ollama` on port 11434)
- [x] **`Llama-3.2-1B-Instruct-Q4_K_M.gguf` (771 MB)**: Ready for Android/PocketPal AI
- [x] **`Llama-3.2-3B-Instruct-Q4_K_M.gguf` (1.9 GB)**: Ready for ThinkPad / fast CPU inference
- [x] **`Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf` (4.4 GB)**: Ready for ThinkPad coding/engineering

---

## 2. Tactical & Mobile Software (`00_BOOTSTRAP/` - ~1.5 GB)
- [x] **Core Android APKs (932 MB)**: `kiwix-android.apk`, `meshtastic.apk`, `organic-maps.apk`, `pocketpal-ai.apk`, `localsend.apk`, `briar.apk`, `bitchat.apk`, `librera.apk`, `trail-sense.apk`, `termux.apk`, `keepassdx.apk`, `vlc.apk`, `lemuroid.apk`
- [x] **Universal Linux AppImages (432 MB)**: `kiwix-desktop.AppImage`, `LocalSend-x86_64.AppImage`, `KeePassXC-x86_64.AppImage`, `organic-maps-desktop.flatpak`, `rpi-imager.AppImage`
- [x] **Windows Portable Tools (175 MB)**: `kiwix-desktop_windows_x64.zip`, `LocalSend-windows-portable.zip`
- [x] **`arduino-cli` Linux 64-bit binary (17 MB)**: Lightweight compiler & flasher

---

## 3. Hardware, Radio & Python Toolchains (`02_ENGINEERING/` - 8.3 GB)
- [x] **Offline Python Wheels (14 MB)**: `pyserial`, `esptool`, `meshtastic`, `cryptography`, `rich`, `click`, `pydantic`, `httpx`, `bleak`
- [x] **Cached Arduino ESP32 Core**: Fully installed in `arduino/data/` (for Cardputer & M5Stack S3)
- [x] **Cached Arduino AVR Core**: Fully installed in `arduino/data/` (for Uno, Nano, Mega)
- [x] **Arduino Libraries**: `M5Unified`, `M5GFX`, `M5Cardputer`, `IRremote`, `LibSSH-ESP32`
- [x] **Radio Emergency Frequency Matrix**: `standard_emergency_frequencies.csv` (NOAA 1-7, MURS 1-5, FRS/GMRS 1-22, 2m/70cm calling, plus Chatham-Kent Top 10 Shortlist & `CHATHAM_KENT_UVK5_GUIDE.md`)
- [x] **MeshCore & Meshtastic Offline Firmware + Flasher**: `02_ENGINEERING/lora_mesh/` (Heltec V4/V3, T1000-E, RAK4631 Room Server/Repeater/Companion binaries, `flash-mesh-node.sh`, & serial CLI cheat sheet)

---

## 4. Knowledge & Field Manuals (`01_KNOWLEDGE/` - 191 MB)
- [x] **Survival Manual ePub (4.9 MB)**: `LigiSurvivalManual.epub` formatted for Kindle, iPad, and mobile
- [x] **Organic Maps Offline Packs (673 MB)**: `01_KNOWLEDGE/maps_mwm/260928/` (`World`, `WorldCoasts`, Ontario London/Chatham-Kent, Toronto, Barrie, Kingston, Metro Detroit)
- [ ] **WikiMed Maxi ZIM (1.86 GB)**: Resumable archive queued (`04_SCRIPTS/download-core.sh`)
- [ ] **WikiHow Maxi ZIM (~8 GB)**: Queued for large storage profile (`usb128` / `sata`)

---

## 5. Physical Media Stamping & Cold Mirroring (`04_SCRIPTS/`)
- [x] **Vault Sync Script**: `04_SCRIPTS/sync-vault.sh` (with `sd32`, `usb128`, and `sata` profiles)
- [x] **NAS Cold Sync Script**: `04_SCRIPTS/sync-nas.sh` (targeting Synology DS220+ at `10.1.1.2`)
- [ ] **MicroSD Card Stamped**: Plug in 32GB MicroSD and run `./04_SCRIPTS/sync-vault.sh --profile sd32 --target /run/media/USER/CARD`
- [ ] **USB Drive Stamped**: Plug in 128GB USB and run `./04_SCRIPTS/sync-vault.sh --profile usb128 --target /run/media/USER/USB`
- [ ] **NAS Backup Executed**: Run `./04_SCRIPTS/sync-nas.sh`
