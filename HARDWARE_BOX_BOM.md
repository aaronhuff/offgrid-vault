# Off-Grid Vault: Modular Hardware Box Specifications & BOM

A pure-DC, modular, Faraday-protected disaster IT & communications architecture designed around **zero AC inverter losses**, **zero scarce SBC dependencies**, and **exponential scaling**—allowing anyone with a salvaged phone, tablet, or laptop to join, download tools, and become a redundant node in the local mesh.

---

## Core Philosophy (Zero-RPi, Laptop + Hub + Mesh)
1. **Compute = Salvaged/Used Business Laptop (ThinkPad USB-C PD):** Replaces fragile, hard-to-source SBCs. Built-in screen, keyboard, battery (UPS), and enough power to run `kiwix-serve`, HTTP/FTP, **LocalSend**, **Ollama/llama.cpp**, and **Arduino/CHIRP**—then **0W** when closed.
2. **Network = 5V USB-C PD Travel Router (GL.iNet):** Powers off *any* USB-C PD bank, Module B, or laptop port. Mounts a USB/SSD directly to serve **HTTP/FTP**, while supporting **LocalSend** and **Briar** over local Wi-Fi. *(ThinkPad hotspot works as fallback; Outdoor DC-PoE AP is optional base-camp gear.)*
3. **Comms = GMRS/RF Voice + Pod Mesh:** **GMRS / UV-K5** with foldable whip antennas bridges pod-to-pod voice; **Bitchat (BLE)** and **Briar (BLE + local Wi-Fi)** handle pod-level SMS replacement; **LoRa (Meshtastic/MeshCore)** adds silent multi-mile text if needed.
4. **Organic Propagation:** No complex sync daemons—files spread organically via **Router HTTP/FTP**, **LocalSend** (phone-to-phone), and **`sd32`/`usb128` sneaker-net**.
5. **Faraday / EMP Protection:** Nothing survives if unshielded electronics fry first. Use a **foam-lined steel ammo can (Fat-50 / 40mm)**—cheap, waterproof, and everywhere—with **antennas detached and cables unplugged**.

---

## System Architecture Overview

| Module | Case / Enclosure | Est. Cost | Role |
| :--- | :--- | :--- | :--- |
| **Module A: Comms, Storage & Faraday Vault** | **Fat-50 / 40mm Steel Ammo Can** (foam-lined) or VEVOR `0.565 Cu.ft` (`13.39" × 9.25" × 4.96"`) | **~$260 – $420** | Radios, LoRa nodes, 6" e-readers, admin Android, GL.iNet router, NVMe/USB/MicroSD + OTG adapters, spares. |
| **Module B: Commodity Solar Power Hub** | **Anker SOLIX C300 DC** (or EcoFlow River 2/3 / Jackery 300 Plus) | **~$150 – $200** (+ $90–$140 panel) | **~288 Wh LiFePO4**, pure-DC (no AC inverter loss on C300 DC), built-in MPPT solar + 140W USB-C PD + 12V socket. *(DIY 2× 10Ah VEVOR option below).* |
| **Field Compute (Separate / Go-Bag)** | Used **ThinkPad T480 / X280** (USB-C PD) in Faraday sleeve | **$130 – $180** | Primary engineering workstation, Kiwix/web server, local 7B AI (`qwen2.5-coder:7b`), radio/ESP32 programmer. |

---

## Module A: Comms, Storage & Faraday Vault (`0.565 Cu.ft`)

**Target Case:** VEVOR `342413` (`0.565 Cu.ft`, `13.39" × 9.25" × 4.96"` int., ~$40) for daily grab-and-go, **OR** a **Fat-50 / 40mm Steel Ammo Can** (~$20–$35) for EMP-proof Faraday storage.  
**Faraday Rule:** For true EMP/RF shielding without clunky pouches, line a **steel ammo can** with **1/4"–1/2" closed-cell foam** (prevents shorts), sand/strip paint off the inner lid contact lip (or add conductive EMI gasket tape) for 360° metal-to-metal contact, and store all gear with **antennas detached and cables unplugged**.

| Category | Component | Est. Price | Notes / Repo Integration |
| :--- | :--- | :--- | :--- |
| **Case & Shielding** | **Fat-50 / 40mm Steel Ammo Can** + closed-cell foam (or VEVOR `342413` grab-box) | **$25 – $45** | Waterproof rubber gasket + welded steel Faraday cage. Toss 2–3× silica gel desiccant packs inside. |
| **Travel Router (USB-C PD)** | GL.iNet Opal (`$30`) or Beryl AX (`$85`) | **$30 – $85** | ~3W from any USB-C PD bank/port. Serves USB SSD over **HTTP/FTP**, plus Wi-Fi LAN for **LocalSend** & **Briar**. |
| **Field E-Readers (1–2×)** | Used 6" **Kindle Basic/Paperwhite** or **Kobo Nia/Clara** | **$30 – $50 ea** | `~6.2" × 4.3" × 0.34"`, foam-nested (never in lid). Synced via `04_SCRIPTS/sync-kindle.sh`. |
| **Admin / Mesh Phone (1×)** | **Spare phone (Pixel on GrapheneOS / Moto on LineageOS)** or cheap rugged Android (see below) | **$0 – $120** | 100% offline, Wi-Fi/BLE/OTG. Runs Kiwix, Organic Maps, PocketPal AI, **Bitchat**, **Briar**, **LocalSend**, **Meshtastic**. |
| **VHF/UHF / GMRS Radios (2×)** | Quansheng UV-K5 or 5W GMRS handhelds + **foldable whip antennas** | **$25 – $35 ea** | Pod-to-pod voice backbone; antennas detached in Faraday storage. Programmed via `02_ENGINEERING/radio_chirp/`. |
| **LoRa Mesh Nodes (2×)** | Seeed T1000-E or Heltec V3 | **$25 – $40 ea** | Flashed via `02_ENGINEERING/lora_mesh/flash-mesh-node.sh`. |
| **Durable Storage & OTG** | 1× 500GB–1TB NVMe ($12 USB-C enclosure) + 2× 128GB metal USBs (`Samsung BAR Plus`) + 2–4× MicroSDs + **3× $3 USB-C/A OTG MicroSD readers** | **$95 – $125** | NVMe = fast master; metal USBs + MicroSDs = universal waterproof copies readable by any phone/laptop via OTG. Refresh yearly via `sync-vault.sh`. *(Keep 2.5" HDD at home base).* |
| **Redundant Spares** | 1× spare 12V→5V buck, USB-C/Lightning cables, laminated QR/freq cards | **$15 – $25** | — |

---

## Module B: Solar Power & Charging Hub (Commodity First)

### Primary Pick: Off-the-Shelf Pure-DC LiFePO4 Station (~$150 – $200)
Building a custom MPPT + fuse + shunt box is clunky when commodity LiFePO4 stations are cheaper, lighter (~6 lbs), and include built-in BMS, MPPT, and USB-C PD:
* **Top Pick — Anker SOLIX C300 DC (~$150–$200):** **288 Wh LiFePO4**, **zero AC inverter** (pure DC efficiency), built-in **100W MPPT solar input (XT60)**, multiple **140W/100W USB-C PD** ports (charges ThinkPad + phones + GL.iNet router simultaneously), and a 12V car socket.
* **Alternatives (~$180–$230):** **EcoFlow River 2/3** or **Jackery Explorer 300 Plus** (LiFePO4, built-in MPPT + USB-C PD; keep AC inverter switched **OFF** to avoid idle drain).
* **Solar Pairing:** **60W–100W folding solar panel** (**$90–$140**) with MC4$\rightarrow$XT60 lead (**~250–450 Wh/sun-day**).
* **What 288 Wh + 60–100W Solar Delivers (Real-World Budget):**
  * *Per full 288 Wh tank (~255 Wh usable DC):* **~16–18 smartphones** (14 Wh ea), **~25+ UV-K5/GMRS radios** (9 Wh ea), **~40+ 6" e-readers** (6 Wh ea), **~80+ hrs of GL.iNet router** (3W), or **~3–5 ThinkPad T480 charges** (55 Wh ea).
  * *Daily steady-state with solar:* Easily sustains a **family/pod of 4–6 phones + 2–4 radios + 2 e-readers + 8–12 hrs of travel router Wi-Fi every day**, plus **1–2 ThinkPad recharges/week**—and scales horizontally (add a second C300 DC) or vertically (bigger panel/station).
* **Downside & Trade-Off:** Sealed all-in-one stations are **not field-repairable** if the internal BMS or MPPT board fails. We accept that trade-off for weight, price, and zero-wiring simplicity—or choose the DIY Module B below if repairability is your top priority.
* **EMP/Faraday Note:** Store the power station in a Faraday bag/lined metal bin when not in use, with solar/USB cables unplugged.

### Optional DIY Alternative: Field-Serviceable VEVOR Box (~$225 – $285)
Only build this if you specifically want **individually replaceable commodity 12V cells and MPPT** rather than an integrated unit:
* **Case:** VEVOR `342413` (`0.565 Cu.ft`, **$40**)
* **Batteries:** 2× **12V 10Ah LiFePO4** in parallel (**$83/pair**, 256 Wh nominal / ~210 Wh usable, dual BMS redundancy)
* **Power Electronics:** 10A–15A MPPT (**$35–$65**), 4-way blade fuse block + master switch (**$18–$25**), 12V→USB-C PD 65W–100W panel (**$18–$25**), inline DC watt meter (**$12–$18**), Solar In (XT60) + 12V Aux In/Out (XT60/Anderson) (**$20–$30**).

---

## Comms & Organic File Propagation Stack

| Layer | Tool | Purpose | Works Without Router? |
| :--- | :--- | :--- | :--- |
| **Pod-to-Pod Voice** | **GMRS / UV-K5 + Foldable Whip** | Primary voice bridge between pods/camps (miles of range) | **Yes** (direct RF) |
| **Pod Text (Cross-Platform)** | **Bitchat** (BLE) | Phone-to-phone BLE mesh chat (iOS + Android) within a pod | **Yes** (0 infrastructure) |
| **Pod Text & Forums (Android)** | **Briar** (BLE + Local Wi-Fi) | Offline messaging/forums over BLE *and* auto-syncs over Travel Router Wi-Fi | **Yes** (BLE) + **Wi-Fi boost** |
| **Organic File Seeding** | **LocalSend** + **Router HTTP/FTP** | AirDrop-style phone-to-phone sharing + browser/FTP downloads from USB/SSD | Needs Travel Router or Hotspot |
| **Silent Multi-Mile Text** | **Meshtastic / MeshCore** | Optional low-power LoRa text/GPS bridge between pods | **Yes** (direct LoRa) |
| **Knowledge / Maps** | **Kiwix** + **Organic Maps** | Offline Wikipedia, WikiMed, Khan Academy `.zim`s & vector topo maps | Local on device or via Router/Laptop |

---

## Recommended Field Laptop & Prepper Phones

### Field Laptop (USB-C PD)
| Laptop (Used Business Class) | Est. Price | Weight | Why It Fits |
| :--- | :--- | :--- | :--- |
| **ThinkPad T480 (14")** *(Top Pick)* | **$130 – $180** | ~3.6 lbs | Dual-battery Bridge System, **USB-C PD charging** (runs off Module B), spill-resistant keyboard, upgradeable RAM/NVMe, bulletproof Linux support. |
| **ThinkPad X280 / X390 (12.5"–13.3")** | **$120 – $170** | ~2.5 lbs | Compact magnesium chassis, USB-C PD charging. |
| **ThinkPad T14 Gen 1/2 AMD** | **$200 – $260** | ~3.2 lbs | Runs `qwen2.5-coder:7b` (`03_INTELLIGENCE/`) locally alongside Arduino/CHIRP. |

### Cheap Rugged / Prepper Phones (Offline Pocket Nodes)
| Phone Option | Est. Price | Key Prepper Features |
| :--- | :--- | :--- |
| **Your Old Spare Phone / Used Moto G Power** | **$0 – $50** | Built-in **MicroSD slot**, 5,000mAh battery, OTG host, headphone jack (FM radio on many models). Debloat via ADB or flash **LineageOS**. |
| **Used Google Pixel (6a / 7a)** | **$100 – $140** | Runs **GrapheneOS** (100% Google-free, hardened offline OS). Pair with a $3 USB-C OTG MicroSD reader. |
| **Used Samsung Galaxy XCover Pro** *(Sleeper Pick)* | **$80 – $120** | IP68 waterproof, MIL-STD-810G, **user-removable battery** (carry spares!), MicroSD slot, **LineageOS** support. |
| **Ulefone Armor X13 / Oukitel WP23 / Doogee S41** | **$90 – $130** (New) | IP68/IP69K drop/waterproof brick, **6,000–10,600mAh battery**, MicroSD slot, OTG. *(Debloat via ADB and keep permanently offline/Airplane mode).* |
