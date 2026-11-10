# Off-Grid Vault: Golden Master Manifest

## Architecture & Redundancy Overview
This directory is the local primary Golden Master ("Honey Hole") for the off-grid disaster preparedness kit.
All data is curated here on NVMe and stamped out to portable flash media using `04_SCRIPTS/sync-vault.sh`.

### Target Profiles
1. **Pocket Life-Support (`sd32`)**:
   - Target Media: 32 GB MicroSD (ExFAT)
   - Budget: < 29 GB
   - Contents:
     - `00_BOOTSTRAP/apks/` (Kiwix, Meshtastic, Organic Maps, VLC)
     - `01_KNOWLEDGE/zim/` (WikiMed, WikiHow, Top-50k Wikipedia)
     - `01_KNOWLEDGE/manuals_pdf/` (First aid, survival, military FMs)
     - `01_KNOWLEDGE/kindle_books/` (Survival ePubs)

2. **Engineering & Tech Core (`usb128`)**:
   - Target Media: 128 GB USB-A Flash Drive (ExFAT)
   - Budget: < 118 GB
   - Contents:
     - Everything in `sd32`
     - `00_BOOTSTRAP/appimages/` (Arduino IDE, CHIRP, Kiwix-desktop)
     - `02_ENGINEERING/` (Self-contained Arduino + ESP32/AVR toolchains, Quansheng/Retevis radio presets, datasheets, pinouts)
     - `03_INTELLIGENCE/` (Quantized 3B & 7B GGUF models + standalone `llama-cli`)

3. **Deep Cold Archive (`sata`)**:
   - Target Media: 2.5" External SATA Drive / SSD
   - Contents: Full 1:1 mirror of everything above + full git repositories, personal documents, and deep archives.

4. **Home Base Tier (`nas`)**:
   - Target Media: Synology DS220+ cold share (`/volume1/cold-vault/`)
