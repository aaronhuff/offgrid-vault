# MeshCore & Meshtastic Air-Gapped Field Guide

Offline flashing, RF coexistence, and serial configuration reference for **MeshCore** and **Meshtastic** nodes in **Chatham-Kent, Ontario** (`US/CA 915 MHz ISM`).

---

## 1. Chatham-Kent LoRa Mesh Architecture & RF Coexistence

Running both **MeshCore** (deterministic multi-hop routing + store-and-forward BBS Room Server) and **Meshtastic** (ad-hoc flood messaging + GPS telemetry) side by side works cleanly if you keep two physical rules in mind:

| Network | US/CA Default Frequency | Radio Preset | Role in Kit |
| :--- | :---: | :--- | :--- |
| **Meshtastic** | `906.875 MHz` (Slot 20) | LongFast (`BW 250 kHz`, `SF 11`, `CR 4/5`) | Family/civilian flood comms, GPS sharing, Android app (`00_BOOTSTRAP/apks/meshtastic.apk`) |
| **MeshCore** | `910.525 MHz` | US/CA Default (`BW 250 kHz`, `SF 11`, `CR 5`) | Dedicated fixed Repeater + **Heltec V4 Room Server** BBS + Companion nodes |

> [!WARNING]
> **Heltec V4 27–28 dBm PA Precaution:** Unlike the Heltec V3 (22 dBm direct from SX1262), the **Heltec V4** includes a dedicated front-end power amplifier (~500–600 mW). **ALWAYS connect the IPEX-to-SMA pigtail and 915 MHz antenna before plugging in USB-C or battery power**—transmitting into an open antenna port can permanently damage the PA.

- **Physical Antenna Separation:** Keep your stationary MeshCore Repeater/Room Server and your Meshtastic base node at least **3–6 feet (1–2 m) apart** so a transmit burst on one does not desensitize the SX1262 receiver front-end of the other.

---

## 2. Cached Offline Firmware Inventory & Flashing

All binaries are cached locally under `02_ENGINEERING/lora_mesh/` (downloaded via `./04_SCRIPTS/download-mesh-firmware.sh`) and flashed offline with `./02_ENGINEERING/lora_mesh/flash-mesh-node.sh` using the pre-cached `esptool` and `pyserial` wheels in `02_ENGINEERING/python_wheels/`.

### List Cached Firmwares & Connected Ports

```bash
./02_ENGINEERING/lora_mesh/flash-mesh-node.sh --list
```

### Flashing ESP32-S3 Boards (Heltec V4 / Heltec V3)

1. Attach the 915 MHz antenna first.
2. Put the board into **ESP32-S3 Download Mode** if automatic reset fails: hold the **`BOOT` / `PRG`** button while plugging in the USB-C data cable (or hold `BOOT`, tap `RST`, then release `BOOT`).
3. Pass **`--erase`** whenever switching a board between Meshtastic and MeshCore (clears incompatible NVS/LittleFS partitions):

```bash
# Flash Heltec V4 as a MeshCore Room Server (fresh/clean flash)
./02_ENGINEERING/lora_mesh/flash-mesh-node.sh \
  --port /dev/ttyACM0 \
  --firmware ./02_ENGINEERING/lora_mesh/meshcore/heltec_v4_room_server-v1.18.0-81dbae5-merged.bin \
  --erase

# Flash Heltec V4 as a MeshCore Repeater
./02_ENGINEERING/lora_mesh/flash-mesh-node.sh \
  --port /dev/ttyACM0 \
  --firmware ./02_ENGINEERING/lora_mesh/meshcore/heltec_v4_repeater-v1.18.0-81dbae5-merged.bin \
  --erase

# Flash Heltec V4 as a MeshCore Companion (BLE for phone, or USB for laptop)
./02_ENGINEERING/lora_mesh/flash-mesh-node.sh \
  --port /dev/ttyACM0 \
  --firmware ./02_ENGINEERING/lora_mesh/meshcore/heltec_v4_companion_radio_ble-v1.18.0-81dbae5-merged.bin \
  --erase

# Flash Heltec V4 with Meshtastic Factory Image
./02_ENGINEERING/lora_mesh/flash-mesh-node.sh \
  --port /dev/ttyACM0 \
  --firmware ./02_ENGINEERING/lora_mesh/meshtastic/extracted/firmware-heltec-v4-2.7.26.54e0d8d.factory.bin \
  --erase
```

*(Note: `-merged.bin` and `*.factory.bin` images flash at `0x00000`; standard app-only `.bin` images flash at `0x10000` — `flash-mesh-node.sh` selects the offset automatically.)*

### Flashing nRF52840 Boards (`UF2` — Seeed T1000-E / RAK4631)

1. Enter UF2 bootloader mode (**RAK4631**: double-tap `RST`; **T1000-E**: hold button while attaching magnetic USB cable or double-tap reset pin / use app DFU).
2. Copy the `.uf2` file onto the mounted USB drive (e.g. `/run/media/$USER/T1000-E` or `RAK4631`):

```bash
./02_ENGINEERING/lora_mesh/flash-mesh-node.sh \
  --port /run/media/$USER/T1000-E \
  --firmware ./02_ENGINEERING/lora_mesh/meshcore/t1000e_companion_radio_ble-v1.18.0-81dbae5.uf2
```

---

## 3. MeshCore Room Server & Repeater USB Serial CLI Cheat Sheet

Connect over USB-C at **`115200` baud (8N1)** immediately after flashing (or anytime via USB):

```bash
# Using pyserial miniterm (installed offline from 02_ENGINEERING/python_wheels/)
python3 -m serial.tools.miniterm /dev/ttyACM0 115200

# Or using minicom (from 00_BOOTSTRAP/packages/ubuntu_noble_core/)
minicom -D /dev/ttyACM0 -b 115200
```

Press `Enter` once connected to see the MeshCore console prompt.

### Essential Configuration Commands

| Command | Example / Value | Purpose |
| :--- | :--- | :--- |
| `ver` / `board` | `ver` | Show firmware version, build date, and board target |
| `clock` / `clock sync` | `time 1794950400` (or `clock sync`) | View RTC clock or set Unix epoch timestamp (`date +%s` on Linux) |
| `set name <Name>` | `set name CK-Room-01` | Set Room Server or Repeater display name |
| `set password <Pass>` | `set password MyAdminPass` | Set admin login password (max 15 chars — **change default immediately**) |
| `set guest.password <Pass>` | `set guest.password ""` | Set Room Server guest password (empty `""` allows open guest access) |
| `set lat <Lat>` / `set lon <Lon>` | `set lat 42.4048` / `set lon -82.1910` | Set Chatham-Kent GPS coordinates for node advertisement |
| `set freq <MHz>` | `set freq 910.525` | US/CA 915 MHz MeshCore default channel |
| `set bw <kHz>` / `set sf <N>` / `set cr <N>` | `set bw 250` / `set sf 11` / `set cr 5` | Match US/CA radio parameters (`BW 250`, `SF 11`, `CR 5`) |
| `set tx <dBm>` | `set tx 27` (Heltec V4) / `set tx 22` (V3) | Set TX power in dBm (`27`–`28` max for Heltec V4 PA; `22` for bare SX1262) |
| `set af <factor>` | `set af 0` (or `2`) | Set airtime duty-cycle factor (`0` = unrestricted in emergency) |
| `set repeat <on\|off>` | `set repeat on` | Enable/disable packet repeating (Repeater/Room Server) |
| `advert` | `advert` | Broadcast an immediate signed node advertisement |
| `neighbors` | `neighbors` | Show recently heard repeater/room-server neighbors and SNR/RSSI |
| `clear stats` | `clear stats` | Reset packet/airtime counters |
| `reboot` | `reboot` | Reboot node to apply any pending radio/name settings |
| `start ota` | `start ota` | Start Wi-Fi OTA update mode (ESP32 Repeaters / Room Servers) |

### Quick Heltec V4 Room Server Initial Setup Sequence

```text
set name CK-Vault-BBS
set password <YOUR_ADMIN_PASS>
set guest.password ""
set lat 42.4048
set lon -82.1910
set freq 910.525
set bw 250
set sf 11
set cr 5
set tx 27
set repeat on
time <CURRENT_UNIX_EPOCH>
advert
reboot
```

*(Get current epoch offline from your laptop clock with `date +%s`.)*

---

## 4. Meshtastic Offline Python CLI Cheat Sheet

Install the cached `meshtastic` CLI completely offline from `02_ENGINEERING/python_wheels/`:

```bash
python3 -m pip install --user --no-index --find-links=./02_ENGINEERING/python_wheels/ meshtastic
```

### Common Meshtastic USB Serial Commands

```bash
# Inspect connected node info, firmware version, and config
meshtastic --port /dev/ttyACM0 --info

# List all heard nodes on the mesh (SNR, battery, hops, coordinates)
meshtastic --port /dev/ttyACM0 --nodes

# Set region to US/Canada (902-928 MHz) and LongFast preset
meshtastic --port /dev/ttyACM0 --set lora.region US --set lora.modem_preset LONG_FAST

# Send a broadcast text message over the primary channel
meshtastic --port /dev/ttyACM0 --sendtext "Vault check-in: all systems nominal"

# Backup and restore full node configuration YAML offline
meshtastic --port /dev/ttyACM0 --export-config > my_node_backup.yaml
meshtastic --port /dev/ttyACM0 --configure my_node_backup.yaml
```
