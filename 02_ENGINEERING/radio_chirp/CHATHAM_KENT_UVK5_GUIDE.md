# Chatham-Kent UV-K5 Emergency & Local Frequency Guide

Local offline field reference for the **Quansheng UV-K5** configured for **Chatham-Kent, Ontario** (receive-only monitoring for emergency services, rail, weather, and aviation; licensed/FRS-compliant transmit only where authorized).

---

## 1. The Chatham-Kent Top 10 Shortlist

| # | Band on Screen (F+1 to change) | Exact 6 Digits to Type | Screen Should Read | What It Is |
| :---: | :--- | :--- | :--- | :--- |
| 1 | F3 | `1 6 2 5 5 0` | `162.55000` | 24/7 Weather Radio (US NOAA Detroit/Lake St. Clair) |
| 2 | F3 | `1 6 1 6 5 0` | `161.65000` | 24/7 Coast Guard Marine Weather (Grande Pointe / Lake St. Clair) |
| 3 | F3 | `1 6 1 7 7 5` | `161.77500` | 24/7 Coast Guard Marine Weather (Lake Erie) |
| 4 | F6 | `4 1 4 1 3 7` | `414.13750` | Chatham-Kent Fire Dispatch (Main UHF Water Tower Repeater) |
| 5 | F3 | `1 5 4 6 8 0` | `154.68000` | Chatham-Kent Fire Dispatch (VHF Paging) |
| 6 | F3 | `1 4 7 1 2 0` | `147.12000` | Chatham Main Ham Repeater (VE3KCR) — Local chatter & storm nets |
| 7 | F3 | `1 6 1 4 1 5` | `161.41500` | CN & VIA Rail Trains (Main road channel through Chatham + track detectors) |
| 8 | F3 | `1 6 1 4 7 5` | `161.47500` | CPKC Freight Trains (Main road channel through Chatham) |
| 9 | F6 | `4 6 2 5 6 2` | `462.56250` | Walkie-Talkie Channel 1 (FRS/GMRS most common local channel) |
| 10 | F2 (+ AM ON) | `1 2 2 9 7 5` | `122.97500` | Chatham-Kent Airport (CYCK) Automated Weather |

> **Step Note for #4 & #9:** If typing 6 digits stops at `414.13500` or `462.56000`, set **`MENU` -> `STEP` -> `6.25K`**, then press **Up** once to land on `.13750` or `.56250`.
> **CHIRP Import:** All 10 channels (plus regional airband) are saved in `02_ENGINEERING/radio_chirp/chatham_kent_top10.csv`.

---

## 2. Chatham-Kent & Regional Airband AM (`F2` + `AM ON`) Frequencies

The UV-K5 cannot receive commercial AM broadcast stations (530–1710 kHz), because its hardware tunes 18 MHz and above. However, all civil aviation operates in **AM mode** on band **`F2` (108–136 MHz)**. Press **`F` + `1`** until **`F2`** appears, and turn **`MENU` -> `AM` -> `ON`**.

### 24/7 Automated Airport Weather (Best for Antenna Testing)

| Exact 6 Digits | Screen Reads | Station | Notes |
| :--- | :--- | :--- | :--- |
| `1 2 2 9 7 5` | `122.97500` | **Chatham-Kent Airport (CYCK) AWOS** | Local ground transmitter at CYCK (best outdoors or with folding tactical antenna) |
| `1 3 4 5 0 0` | `134.50000` | **Windsor Airport (CYQG) ATIS** | Continuous weather & runway broadcast |
| `1 3 3 6 7 5` | `133.67500` | **Detroit Metro (KDTW) ATIS** | High-power continuous broadcast across Lake St. Clair |
| `1 2 7 8 0 0` | `127.80000` | **London Airport (CYXU) ATIS** | Continuous weather & runway broadcast |
| `1 2 6 4 0 0` | `126.40000` | **Sarnia Airport (CYZR) AWOS** | Automated weather north of Chatham-Kent |

### High-Altitude ATC Overhead (Active Commercial Airliner Corridor)

| Exact 6 Digits | Screen Reads | What It Is |
| :--- | :--- | :--- |
| `1 3 5 3 0 0` | `135.30000` | **Toronto Centre ATC (Southwestern ON)** — Main commercial jet traffic over Chatham |
| `1 3 4 3 0 0` | `134.30000` | **Detroit Approach / Departure** — Jets descending into / climbing out of Detroit over Lake St. Clair |
| `1 3 2 4 2 5` | `132.42500` | **Cleveland Center ATC (Lake Erie / Windsor Sector)** — Cross-border jet traffic |

### Local Traffic & Emergency

| Exact 6 Digits | Screen Reads | What It Is |
| :--- | :--- | :--- |
| `1 2 2 8 0 0` | `122.80000` | **Chatham-Kent Airport (CYCK) Unicom / ATF** — Local small planes, crop dusters & training traffic |
| `1 2 6 7 0 0` | `126.70000` | **Southern Ontario VFR Enroute** — General aviation position & weather reports |
| `1 2 4 7 0 0` | `124.70000` | **Windsor Tower (CYQG)** — Aircraft approaching/departing Windsor |
| `1 2 1 5 0 0` | `121.50000` | **International Aviation Emergency ("Guard")** — SAR helicopters, Medevac (Ornge), & distress calls |
| `1 2 3 4 5 0` | `123.45000` | **Air-to-Air Chat** — Informal pilot-to-pilot & helicopter coordination |

### Egzumer Firmware Bonus (Highway 401 & Clean AM)

- **`AM Fix` AGC:** Flashing `02_ENGINEERING/radio_chirp/firmware/quansheng_egzumer_v0.22.bin` enables **`AM Fix`**, fixing the stock firmware's lack of AM AGC so nearby aircraft come through cleanly without distortion.
- **CB Channel 19 (`27.18500` MHz AM):** Unlocked on Egzumer firmware (18–32 MHz AM receive) for monitoring truckers along the **Highway 401 corridor** reporting closures, accidents, and winter whiteouts.

---

## 3. UV-K5 Front-Panel Keypad & Walkie Pairing Reference

| Key Combo / Menu | Function | Practical Tip |
| :--- | :--- | :--- |
| **`F` + `1`** | Change Frequency Band (`F1`–`F7`) | Select `F2` (Airband), `F3` (VHF 136–174 MHz), `F6` (UHF 400–470 MHz) |
| **`F` + `2`** | Save Memory Channel (`M-SAVE`) | Dial frequency + mode first, press `F` + `2`, pick `CH-xxx` with Up/Down, press `MENU` |
| **`F` + `3`** | Toggle VFO / Memory Mode (`V/M`) | Switch between manual frequency typing (VFO) and saved channels |
| **`F` + `4`** | Frequency / CTCSS Copy | **Pair with Retevis 777HD walkies:** Hold walkie nearby and transmit while UV-K5 is in `F`+`4` scan to clone exact FRS frequency + privacy tone |
| **`F` + `0`** | Commercial FM Broadcast Radio | Listen to local 88–108 MHz FM stations (e.g., emergency news bulletins) |
| **`MENU` -> `STEP`** | Tuning Step Size | Use **`6.25 kHz`** for `.13750` / `.56250` UHF channels; **`25.0 kHz`** for Airband AM |
| **`MENU` -> `SQL`** | Squelch Level | Set to **`1`** or **`2`** for AM Airband so weaker/distant aircraft audio isn't clipped |

---

## 4. 2-Pin K1 Serial Cable & `k5prog` Cheat Sheet

> **Important:** The UV-K5 **USB-C port is charge-only** (no data lines are wired to the MCU). All EEPROM backups, CHIRP channel writes, and firmware flashes require the **2-pin Kenwood (K1) USB-to-serial cable**.

1. **Seat the K1 Plug Firmly:** Push the 2-pin plug all the way in until completely flush. Even a 1 mm gap causes serial timeouts or unintended PTT keying.
2. **Normal Power-On Mode (EEPROM Backup / Restore):**
   Turn the radio **ON normally**, set volume to ~75%, plug in the K1 cable, and verify the serial device (`/dev/ttyUSB0`):
   ```bash
   # Backup current radio EEPROM before making any changes
   ./02_ENGINEERING/radio_chirp/k5prog/k5prog -r -v -p /dev/ttyUSB0 -f uv_k5_backup.raw

   # Restore an EEPROM dump (original factory dump is in firmware/stock_original_factory/)
   ./02_ENGINEERING/radio_chirp/k5prog/k5prog -w -v -p /dev/ttyUSB0 -f uv_k5_backup.raw
   ```
3. **Bootloader Mode (Flashing `quansheng_egzumer_v0.22.bin`):**
   - Hold the **`PTT`** button while turning the power knob **ON** — the **top white flashlight LED glows solid** with a blank screen (bootloader mode), then plug in the K1 cable.
   - Verify bootloader communication first with `-Y -D`, then flash:
   ```bash
   # Check bootloader version safely
   ./02_ENGINEERING/radio_chirp/k5prog/k5prog -Y -D -p /dev/ttyUSB0

   # Flash raw decrypted firmware (see k5prog/README before flashing)
   ./02_ENGINEERING/radio_chirp/k5prog/k5prog -YYYYYY -F -p /dev/ttyUSB0 -b ./02_ENGINEERING/radio_chirp/firmware/quansheng_egzumer_v0.22.bin
   ```
