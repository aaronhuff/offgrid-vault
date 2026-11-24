# Off-Grid Vault (`offgrid-vault`)

A pragmatic, pure-DC disaster IT and communications kit built on one core principle: **capture everything useful offline—knowledge, maps, comms, media, and local AI—so it can run on whatever salvaged hardware still works**, backed by a compact, Faraday-protected set of prepped hardware to bootstrap a community.

---

## Core Philosophy

1. **Zero-Inverter, Pure-DC Power:** Skip power-hungry x86 mini-PCs and AC inverters. Run on a **100W folding solar panel $\rightarrow$ Victron MPPT $\rightarrow$ 12V 10Ah LiFePO4 $\rightarrow$ 130W USB-C PD car charger** (everything except the panel shielded inside the Faraday bag).
2. **Salvage-Friendly & Gracefully Degradable:** No single server is a fatal point of failure. Phones and ThinkPads work independently—and any salvaged Android, iPhone, Linux, or Windows machine can join and replicate the stack.
3. **Organic Propagation:** No travel router or complex sync daemons required. Spread files over **ThinkPad Wi-Fi Hotspot + LocalSend** (cross-platform AirDrop), **Bitchat/Briar** (BLE/Wi-Fi pod chat), and **MicroSD + $3 OTG adapters**.
4. **Faraday-First Storage:** Store the ThinkPad, MPPT, 12V battery, USB-C PD chargers, radios, phone, rugged NVMe, and MicroSDs inside a **15L Waterproof Faraday Dry Bag** (antennas detached, cables unplugged, padded inner pouches) for grab-and-go EMP + weather protection.

---

## The 4-Layer Survival Stack

| Layer | Software & Content | Hardware / Delivery |
| :--- | :--- | :--- |
| **1. Knowledge & Navigation** | Kiwix (WikiMed, WikiHow, iFixit `.zim`), Organic Maps (`.mwm`), Librera (EPUB/PDF), Trail Sense | Salvaged phones/tablets, ThinkPad, rugged NVMe + MicroSDs |
| **2. Comms & Seeding** | **GMRS / UV-K5(8)** (pod-to-pod voice + USB-C), **Bitchat** & **Briar** (pod text), **LocalSend** | USB-C rechargeable UV-K5(8)/TD-H3 + foldable whips, ThinkPad Hotspot |
| **3. Local AI (Client-Side)** | **PocketPal AI** + `Llama-3.2-1B/3B` (phones), `llama.cpp` / Ollama + `qwen2.5-coder:7b` (laptops) | Offloaded to client phones & ThinkPads instead of burning central server watts |
| **4. Media & Morale** | **VLC**, `04_MORALE/` (music, radio dramas, cartoons), USB-C magnetic flashlight | Spare/rugged Androids (3.5mm jack + FM tuner + MicroSD) |

*(Optional Engineering / Home-Base Tier: `02_ENGINEERING/` Arduino/ESP32/CHIRP toolchains, `00_BOOTSTRAP/container_images/`, and `05_NAS_HORDE/`.)*

---

## Hardware & Shopping Guide

See **[HARDWARE_BOX_BOM.md](HARDWARE_BOX_BOM.md)** for the full itemized BOM, pricing, power math, Faraday rules, and recommended ThinkPad / rugged phone / VEVOR IP67 case picks.

---

## Quickstart

### 1. Curate Offline Assets (APKs, AppImages, ZIMs, Models)
Downloads Android APKs, universal Linux AppImages, Windows portable tools, Kiwix ZIMs, and quantized GGUF models:
```bash
./04_SCRIPTS/download-core.sh
```

### 2. Stamp Portable Media (MicroSD / USB / SSD)
```bash
# Pocket Survival (Fits on 32GB MicroSD < 29GB)
./04_SCRIPTS/sync-vault.sh --profile sd32 --target /run/media/USER/CARD

# Full Kit & AI (Fits on 128GB Flash Drive / NVMe < 118GB)
./04_SCRIPTS/sync-vault.sh --profile usb128 --target /run/media/USER/USB
```

### 3. Optional: Local LLM & Arduino/ESP32 Setup (ThinkPad)
```bash
./03_INTELLIGENCE/setup-local-llm.sh
./02_ENGINEERING/arduino/setup-offline-cores.sh
```
