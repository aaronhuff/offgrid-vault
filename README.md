# Off-Grid Vault (`offgrid-vault`)

A NASA-redundancy inspired, multi-tiered digital disaster preparedness vault designed for off-grid resilience, minimal power consumption, and air-gapped operation.

## Architecture & Fleet Roles

| Tier | Hardware | Power | Role |
| :--- | :--- | :--- | :--- |
| **Tier 0 (Micro-Power)** | Kindle, Cardputer, M5Stack S3 | 0.1W – 1W | E-ink reading (survival guides, field medicine), hardware bus diagnostics, radio sniffing. |
| **Tier 1 (Tactical Mobile)** | Smartphones, iPad, Meshtastic T1000/C6L, Quansheng UV-K5 | 1W – 5W | Offline GPS mapping (Organic Maps), Kiwix Wikipedia/WikiMed, encrypted mesh texting, analog RF comms. |
| **Tier 2 (Workstation Core)** | Laptop, Raspberry Pi 500 / 4B | 15W – 45W | Local LLMs (Ollama / llama.cpp), self-contained Arduino IDE & ESP32 compiler, radio programming (CHIRP). |
| **Tier 3 (Cold Archive)** | 2.5" External SATA, 32GB MicroSDs, 128GB USBs, Synology NAS | 1.5W – 25W | Air-gapped, bus-powered physical backups and cold mirrors. |

## Quickstart

### 1. Curate Local Cache
Run the curation script to download standalone APKs, Kiwix ZIMs, and quantized GGUF models:
```bash
./04_SCRIPTS/download-core.sh
```

### 2. Set Up Local LLM on Laptop
Starts a rootless Podman Ollama container bound to the local vault:
```bash
./03_INTELLIGENCE/setup-local-llm.sh
podman exec -it offgrid-ollama ollama run llama3.2:3b
podman exec -it offgrid-ollama ollama run qwen2.5-coder:7b
```

### 3. Pre-Cache Arduino & ESP32 Toolchains
Caches offline toolchains for Arduino AVR and ESP32 (Cardputer & M5Stack):
```bash
./02_ENGINEERING/arduino/setup-offline-cores.sh
```

### 4. Stamp Out Media to MicroSD or USB
```bash
# Pocket Survival (Fits on 32GB MicroSD < 29GB)
./04_SCRIPTS/sync-vault.sh --profile sd32 --target /run/media/USER/CARD

# Engineering & AI (Fits on 128GB Flash Drive < 118GB)
./04_SCRIPTS/sync-vault.sh --profile usb128 --target /run/media/USER/USB
```
