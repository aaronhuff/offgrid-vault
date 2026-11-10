# Off-Grid Vault: Implementation & Readiness Checklist

Status Legend:
- [x] **DONE**: Installed, verified, and ready offline.
- [ ] **IN PROGRESS / PENDING**: Queued for download or staging.

---

## 1. Laptop Intelligence & LLM Stack
- [x] Rootless Podman Ollama setup (`~/repos/offgrid-vault/03_INTELLIGENCE/setup-local-llm.sh`)
- [x] `llama3.2:3b` model downloaded & verified (General / First-Aid / Low-Power)
- [x] `qwen2.5-coder:7b` model downloaded & verified (Technical / Coding / Circuits)
- [ ] `Llama-3.2-1B-Instruct-Q4_K_M.gguf` downloaded for Android phone

---

## 2. Tactical & Mobile Software (`00_BOOTSTRAP/`)
- [ ] `kiwix-android.apk` (Offline Wikipedia / WikiMed reader for Android)
- [ ] `meshtastic.apk` (Off-grid mesh texting & GPS mapping for T1000 & C6L)
- [ ] `organic-maps.apk` (Offline global maps & hiking topography)
- [ ] `kiwix-desktop.AppImage` (Offline reader for Laptop / Pi 500)
- [ ] `arduino-cli` Linux binary (Lightweight compiler & flasher)

---

## 3. Knowledge & Medical Archives (`01_KNOWLEDGE/`)
- [ ] `wikipedia_en_medicine_maxi.zim` (WikiMed: Complete clinical medical encyclopedia)
- [ ] `wikihow_en_maxi.zim` (Complete practical repair, survival, first aid guides)
- [ ] `ifixit_en_all.zim` (Electronics, automotive, small appliance repair guides)
- [ ] Military Survival FMs (FM 21-76 Survival, FM 4-25.11 First Aid)

---

## 4. Hardware, Radio & Python Toolchains (`02_ENGINEERING/`)
- [x] Radio emergency frequency presets CSV (`standard_emergency_frequencies.csv`)
- [ ] Cached Python Wheels (`pyserial`, `esptool`, `meshtastic`, `cryptography`, `rich`)
- [ ] Cached Arduino ESP32 core (For Cardputer, M5Stack S3)
- [ ] Cached Arduino AVR core (For Uno, Nano, Mega)

---

## 5. Physical Media & Cold Targets
- [ ] 32GB MicroSD Card stamped (`./04_SCRIPTS/sync-vault.sh --profile sd32`)
- [ ] 128GB Flash Drive stamped (`./04_SCRIPTS/sync-vault.sh --profile usb128`)
- [ ] 2.5" External SATA Drive mirrored (`./04_SCRIPTS/sync-vault.sh --profile sata`)
- [ ] Synology NAS cold share sync script configured (`10.1.1.2`)
