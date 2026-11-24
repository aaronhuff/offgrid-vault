# Off-Grid Vault: Lean Faraday Kit Specifications & BOM

A pure-DC, dual-purpose, Faraday-protected disaster IT & communications kit designed around **zero AC inverter losses**, **zero scarce SBCs**, and **commodity off-the-shelf parts**.

**Physical Split:**
* **External:** Renogy 100W Folding Solar Panel (MC4/XT60).
* **Mission Darkness Dry Shield Faraday Tote 15L (`~$126 CAD`):** Waterproof + EMP-shielded roll-top bag holding **everything else**—ThinkPad (in neoprene sleeve), Victron MPPT, 12V 10Ah LiFePO4, USB-C PD chargers, radios, phone, rugged NVMe + MicroSDs, flashlight, and spares. *(Clear front pocket holds the laminated Quick-Start card).*

---

## Core Philosophy (Zero-Fluff, Dual-Purpose)
1. **Everything Dual-Purpose:** The ThinkPad is both your workstation and Wi-Fi hotspot (`LocalSend` / `kiwix-serve`); the phone is your GPS/EPUB/AI/BLE-mesh node + FM/MP3 player; the radios have built-in flashlights + NOAA; the USB-C flashlight works as a camp/repair light.
2. **Shield the Silicon, Not the Panel:** Keep the ThinkPad, Victron MPPT, 12V LiFePO4 (which has an internal BMS), USB-C PD car chargers, phone, radios, and NVMe inside the **15L Faraday Dry Bag** (with padded pouches/sleeves so sharp edges never pinhole the liner, and roll the top **3 full folds** to seal). Leave only the raw 100W solar panel outside.
3. **Organic Propagation:** ThinkPad Wi-Fi Hotspot + **LocalSend** (phone-to-phone AirDrop) + **Bitchat / Briar** (BLE/Wi-Fi pod chat) + **MicroSDs & $3 OTG readers**—no dedicated travel router or sync daemons required.

---

## Complete Shopping List & Cost (CAD)

| Subsystem | Exact Item | Est. Price (CAD) | Notes / Repo Integration |
| :--- | :--- | :--- | :--- |
| **Waterproof Faraday Bag** | **Mission Darkness Dry Shield Faraday Tote 15L** + padded neoprene laptop/tech pouches + silica gel packs | **~$145** | Waterproof + EMP-shielded in one wearable bag (~6–7L gear leaves plenty of room for 3× roll-top folds). Use padded inner sleeves to protect the liner. |
| **Solar Panel** *(External)* | **Renogy 100W Folding Solar Panel** (MC4 / XT60) | **~$130 – $150** | ~350–450 Wh/sun-day. Use raw MC4/XT60 output only. |
| **MPPT Controller** *(In Bag)* | **Victron SmartSolar MPPT 75/10** *(or **75/15**)* | **~$95 – $115** | Tiny (`3.9"×4.4"`), ~98% efficiency, native LiFePO4, fanless. *(Budget alt: Renogy Wanderer 10A PWM ~$28).* |
| **12V Buffer Battery** *(In Bag)* | **1× 12V 10Ah LiFePO4** *(LiTime / Eco-Worthy)* + **15A inline fuse** | **~$50** | 128 Wh; stabilizes solar voltage for night/clouds. *(Also works with any scavenged 12V car/marine battery).* |
| **12V PD Output** *(In Bag)* | **2× 12V Female Sockets** (15A fused, 1 spare) + **2× 100W–130W USB-C PD Car Chargers** (UGREEN/Anker, 1 spare) + spare 15A ATO fuses | **~$55** | Wired directly to battery terminals. Delivers **20V 65W+ PD** to ThinkPad + simultaneous USB-C charging for phone, radios, and light. |
| **Comms (USB-C Direct)** *(In Bag)* | **2× Quansheng UV-K5(8) / UV-K6** *(or Tidradio TD-H3 GMRS)* + **2× Foldable Whip Antennas** | **~$75 – $95** | **Direct USB-C charging** on battery (no cradle), built-in LED flashlight, NOAA weather, FM radio. Antennas detached in storage. |
| **Lighting** *(In Bag)* | **1–2× Sofirn SC18 / Wurkkos FC11C** (or HS20 headlamp) | **~$30 ea** | **USB-C rechargeable**, standard replaceable 18650 cell, magnetic tailcap (mounts to any steel surface as a work light). |
| **Rugged Storage** *(In Bag)* | **1× 500GB–1TB NVMe in IP67 Rugged Aluminum USB-C Enclosure** (ORICO/Sabrent) + **2× 32GB/64GB MicroSDs** + **3× $3 USB-C/A OTG MicroSD Readers** | **~$95 – $120** | Shock/splash-proof master NVMe + universal MicroSDs readable on any phone/laptop. Refresh yearly via `04_SCRIPTS/sync-vault.sh`. |
| **Cables & Paper** *(In Bag)* | **2× 100W USB-C PD cables** + **1× multi-tip cable** + **3.5mm wired earbuds** + **laminated 1-page Quick-Start** | **~$25** | Quick-Start lists GMRS/NOAA frequencies & Android APK sideloading steps. |
| **Field Compute** *(In Bag)* | **Used ThinkPad T480 / X280** (USB-C PD) | **~$180 – $240** | Runs `kiwix-serve`, ThinkPad Wi-Fi Hotspot, `LocalSend`, `llama.cpp`/Ollama, CHIRP. *($0 if reusing existing laptop).* |
| **Pocket Node** *(In Bag)* | **Spare/Rugged Android** (3.5mm jack + MicroSD + OTG, GrapheneOS/LineageOS or debloated) | **$0 – $130** | Moto G Power (`$0–$50`), Samsung XCover Pro (`$80–$120`), or Ulefone Armor X13 (`$90–$130`). Runs Kiwix, Organic Maps, PocketPal AI, Bitchat, Briar, LocalSend, Librera, Trail Sense, VLC. |

* **Total (reusing an existing ThinkPad, phone, & Renogy 100W panel):** **~$565 – $640 CAD**
* **Total all-in from scratch (excl. panel):** **~$745 – $1,010 CAD** *(+$130–$150 if buying the 100W panel).*

---

## Solar Wiring (10 Minutes, Screwdrivers Only)
```text
[Renogy 100W Panel] ──(MC4/XT60)──▶ [Victron MPPT 75/10: PV +/-]
                                              │
                                      (BATT +/- w/ 15A fuse)
                                              ▼
                                    [12V 10Ah LiFePO4]
                                              │
                                     (Ring terminals w/ 15A fuse)
                                              ▼
                             [12V Female Socket + 130W PD Car Charger]
                                              │
                    ┌─────────────────────────┼─────────────────────────┐
                    ▼                         ▼                         ▼
             [ThinkPad T480]        [UV-K5(8) / TD-H3]         [Android + Flashlight]
              (65W USB-C PD)           (Direct USB-C)               (Direct USB-C)
```
*(Connect the **battery first**, then plug in the **solar panel**.)*

---

## Comms & 4-Layer Software Stack

| Layer | Tool | Purpose |
| :--- | :--- | :--- |
| **Pod-to-Pod Voice** | **UV-K5(8) / GMRS + Foldable Whip** | Primary voice bridge (miles of range) + NOAA weather |
| **Pod Text** | **Bitchat** (BLE) & **Briar** (BLE + Wi-Fi) | Zero-infrastructure phone-to-phone chat & offline forums |
| **Organic File Seeding** | **LocalSend** + **ThinkPad Hotspot** + **MicroSD OTG** | Cross-platform AirDrop for APKs, maps, and books; zero router needed |
| **Knowledge & Maps** | **Kiwix**, **Organic Maps**, **Librera**, **Trail Sense** | Wikipedia/WikiMed/iFixit, topo maps, EPUB/PDF manuals, compass/barometer |
| **Local AI & Morale** | **PocketPal AI** (`Llama-3.2-1B`), **VLC**, `04_MORALE/` | Client-side AI on phones/laptop + music/radio dramas via 3.5mm jack & FM |
