# Off-Grid Vault: "World Knowledge in a Bag" (15L Faraday Kit)

A pure-DC, zero-wiring, grab-and-go disaster IT & communications bunker packed inside **one waterproof, EMP-shielded 15L bag**—built around **commodity USB-C PD**, **zero AC inverter losses**, and **salvaged-device compatibility**.

---

## Core Philosophy (Zero-Fluff, Zero-Wiring)
1. **Everything Fits in One 15L Bag:** **Mission Darkness Dry Shield Faraday Tote 15L** (~$126 CAD) provides both IPX waterproof and EMP/RF shielding in a single wearable dry bag.
2. **No Loose 12V Wiring:** Inside a soft carry bag, a sealed **Anker SOLIX C300 DC** (`4.9" × 4.7" × 7.9"`, 288 Wh LiFePO4, built-in 100W MPPT + 140W USB-C PD + built-in pop-up camp light, zero AC inverter) replaces loose MPPT boards, fuses, and battery terminals.
3. **Dual-Purpose Everything:** The ThinkPad is your workstation + Wi-Fi hotspot (`LocalSend` / `kiwix-serve`); the phone is your GPS/EPUB/AI/BLE-mesh node + FM/MP3 player; the UV-K5(8) radios charge over USB-C and have built-in flashlights + NOAA; the C300 DC has a built-in lantern.
4. **Organic Propagation:** ThinkPad Wi-Fi Hotspot + **LocalSend** (phone-to-phone AirDrop) + **Bitchat / Briar** (BLE/Wi-Fi pod chat) + **MicroSDs & $3 OTG readers**.

---

## Complete 15L Bag Shopping List & Cost (CAD)

| Subsystem | Exact Item | Est. Price (CAD) | Notes / Repo Integration |
| :--- | :--- | :--- | :--- |
| **Waterproof Faraday Bag** | **Mission Darkness Dry Shield Faraday Tote 15L** + neoprene laptop sleeve + silica gel packs | **~$140** | ~10–11L of gear leaves plenty of room for the required **3× roll-top folds**. Clear front pocket holds laminated Quick-Start card. |
| **Pure-DC Power Station** | **Anker SOLIX C300 DC** (`4.9" × 4.7" × 7.9"`, ~6.2 lbs) | **~$160 – $210** | **288 Wh LiFePO4**, **zero AC inverter**, built-in **100W MPPT solar (XT60)**, 140W USB-C PD (runs ThinkPad), and built-in camp light. |
| **Compact Solar Panel** | **40W–60W Multi-Fold Panel (XT60/MC4)** *(fits in bag)* <br>*(Or **Renogy 100W Folding Panel** carried externally)* | **~$75 – $115** | Compact 40W–60W panel (~11"×8" folded) fits inside the 15L bag (~160–260 Wh/sun-day). Plug in a 100W panel at base camp via XT60. |
| **Comms (USB-C Direct)** | **2× Quansheng UV-K5(8) / UV-K6** *(or Tidradio TD-H3 GMRS)* + **2× Foldable Whip Antennas** | **~$75 – $95** | **Direct USB-C charging** on battery (no cradle), built-in LED flashlight, NOAA weather, FM radio. Antennas detached in storage. |
| **Rugged Storage** | **1× 500GB–1TB NVMe in IP67 Rugged Aluminum USB-C Enclosure** (ORICO/Sabrent) + **2× 32GB/64GB MicroSDs** + **3× $3 USB-C/A OTG MicroSD Readers** | **~$95 – $120** | Shock/splash-proof master NVMe + universal MicroSDs readable on any phone/laptop. Refresh yearly via `04_SCRIPTS/sync-vault.sh`. |
| **Cables, Light & Audio** | **2× 100W USB-C PD cables** + **1× USB-C headlamp** (Sofirn/Wurkkos, optional) + **3.5mm wired earbuds** + **laminated Quick-Start** | **~$25 – $55** | Quick-Start lists GMRS/NOAA frequencies & Android APK sideloading steps. |
| **Field Compute** | **Used ThinkPad T480 / X280** (USB-C PD) | **~$180 – $240** | Runs `kiwix-serve`, ThinkPad Wi-Fi Hotspot, `LocalSend`, `llama.cpp`/Ollama, CHIRP. *($0 if reusing existing laptop).* |
| **Pocket Node** | **Spare/Rugged Android** (3.5mm jack + MicroSD + OTG, GrapheneOS/LineageOS or debloated) | **$0 – $130** | Moto G Power (`$0–$50`), Samsung XCover Pro (`$80–$120`), or Ulefone Armor X13 (`$90–$130`). Runs Kiwix, Organic Maps, PocketPal AI, Bitchat, Briar, LocalSend, Librera, Trail Sense, VLC. |

* **Total (reusing an existing ThinkPad, phone, & solar panel):** **~$495 – $590 CAD**
* **Total all-in from scratch:** **~$750 – $1,105 CAD**

*(Note: Sealed power stations trade off component-level repairability for zero-wiring compactness; for a field-serviceable 12V build, pair a Victron SmartSolar MPPT 75/10 + 12V 10Ah LiFePO4 + 12V socket + 130W PD car charger instead.)*

---

## Comms & 4-Layer Software Stack

| Layer | Tool | Purpose |
| :--- | :--- | :--- |
| **Pod-to-Pod Voice** | **UV-K5(8) / GMRS + Foldable Whip** | Primary voice bridge (miles of range) + NOAA weather |
| **Pod Text** | **Bitchat** (BLE) & **Briar** (BLE + Wi-Fi) | Zero-infrastructure phone-to-phone chat & offline forums |
| **Organic File Seeding** | **LocalSend** + **ThinkPad Hotspot** + **MicroSD OTG** | Cross-platform AirDrop for APKs, maps, and books; zero router needed |
| **Knowledge & Maps** | **Kiwix**, **Organic Maps**, **Librera**, **Trail Sense** | Wikipedia/WikiMed/iFixit, topo maps, EPUB/PDF manuals, compass/barometer |
| **Local AI & Morale** | **PocketPal AI** (`Llama-3.2-1B`), **VLC**, `04_MORALE/` | Client-side AI on phones/laptop + music/radio dramas via 3.5mm jack & FM |
