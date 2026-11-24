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

## Module B: Shielded Modular Power & Pass-Around Banks

### Primary Pick: Shielded Silicon + Modular 12V + XTAR Pass-Around Banks
Instead of trapping vulnerable controller boards inside a bulky plastic power station—or relying on sewn-in USB ports on an external solar panel—keep **all power electronics inside the steel Faraday box** and leave only the **dumb MC4/XT60 solar panel** outside:

1. **Solar Panel (External):** **60W–100W folding panel** with **MC4 / XT60** output (**$90–$140**). No reliance on exposed panel USB boards.
2. **Solar Charge Controller (Inside Steel Box):**
   * *Optimal:* **Victron SmartSolar MPPT 75/10 or 75/15** (**~$85–$115 CAD**, ~98% efficiency, native LiFePO4).
   * *Budget:* **Renogy Wanderer 10A PWM** (**~$28 CAD**, supports LiFePO4; ~25% lower solar harvest than MPPT).
3. **12V Buffer Battery (Inside Steel Box or External):** **1–2× 12V 10Ah LiFePO4** (**~$42 CAD ea**) with **15A inline fuse**. *(Also works with any scavenged 12V car/tractor/marine battery).*
4. **12V Socket + 100W USB-C PD Car Charger (Inside Steel Box):** Wire a **12V heavy-duty female cigarette socket (15A fused)** directly to the **12V battery terminals** (not the controller's `LOAD` port), and plug in a commodity **100W–130W USB-C PD car charger** (**UGREEN / Anker, ~$20–$30 CAD**; toss a $15 spare in the box). Delivers true **20V 65W+ PD** to the ThinkPad, router, and fast-charges pass-around banks in ~1.5 hrs.
5. **Pass-Around Pocket Banks (Inside Steel Box):** **2× XTAR PB2SL** (**~$28 CAD ea**) + **4–6× Samsung 50E 21700 cells** (**~$8 CAD ea** from Canadian distributors *Involt.ca*, *Ecigarettes.ca*, or *AffordableEbikes.ca*—never Amazon/eBay for bare cells). Each pair of 50Es gives a **10,000mAh (~36 Wh) swappable USB-C PD bank** to hand out around camp.

*(Plug-and-Play Convenience Alternative: **Anker SOLIX C300 DC**, ~$150–$200, 288 Wh LiFePO4, built-in 100W MPPT + 140W USB-C PD, zero AC inverter—easier out of the box, but non-repairable and too bulky for a Fat-50/40mm steel can.)*

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
