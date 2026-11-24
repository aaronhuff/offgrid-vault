# Off-Grid Vault (`offgrid-vault`)

A pragmatic, pure-DC disaster IT and communications kit built on one core principle: **capture everything useful offline—knowledge, maps, comms, media, and local AI—so it can run on whatever salvaged hardware still works**, backed by a compact, Faraday-protected set of prepped hardware to bootstrap a community.

---

## Core Philosophy

1. **Zero-Inverter, Pure-DC Power:** Skip power-hungry x86 mini-PCs and AC inverters. Run on commodity ~300Wh LiFePO4 USB-C PD power + folding solar.
2. **Salvage-Friendly & Gracefully Degradable:** No single server is a fatal point of failure. Phones, tablets, e-readers, and ThinkPads all work independently—and any salvaged Android, iPhone, Linux, or Windows machine can join and replicate the stack.
3. **Organic Propagation:** No complex sync daemons. Spread files over **USB-C PD Travel Router (HTTP/FTP)**, **LocalSend** (cross-platform Wi-Fi AirDrop), **Bitchat/Briar** (BLE/Wi-Fi pod chat), and **MicroSD/USB + OTG adapters**.
4. **Faraday-First Storage:** Store cold spares, radios, phones, routers, and SSD/MicroSDs inside a **foam-lined steel ammo can (Fat-50 / 40mm)** (antennas detached, cables unplugged) for cheap, waterproof EMP protection.

---

## The 4-Layer Survival Stack

| Layer | Software & Content | Hardware / Delivery |
| :--- | :--- | :--- |
| **1. Knowledge & Navigation** | Kiwix (WikiMed, WikiHow, iFixit `.zim`), Organic Maps (`.mwm`), Survival ePubs/PDFs | 6" E-readers, salvaged phones/tablets, ThinkPad, `sd32` MicroSDs |
| **2. Comms & Seeding** | **GMRS / UV-K5** (pod-to-pod voice), **Bitchat** & **Briar** (pod text), **LocalSend** + **Meshtastic** | Quansheng UV-K5 + foldable whips, GL.iNet USB-C PD Travel Router, LoRa nodes |
| **3. Local AI (Client-Side)** | **PocketPal AI** + `Llama-3.2-1B/3B` (phones), `llama.cpp` / Ollama + `qwen2.5-coder:7b` (laptops) | Offloaded to client phones & ThinkPads instead of burning central server watts |
| **4. Media & Morale** | **VLC**, **Librera** (EPUB/PDF), **Trail Sense**, `04_MORALE/` (music, radio dramas, cartoons) | Spare/rugged Androids (3.5mm jack + FM tuner + MicroSD) |

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
