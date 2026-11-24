# Offline Maps (`01_KNOWLEDGE/maps_mwm/`)

Pre-cached **Organic Maps** `.mwm` vector map packs for 100% offline navigation, topographic contours, address search, and turn-by-turn routing across **Linux Laptop**, **Android**, and **iPhone/iPad**.

All files in [`260928/`](./260928/) match the map dataset version (`260928`) bundled inside [`00_BOOTSTRAP/apks/organic-maps.apk`](../../00_BOOTSTRAP/apks/organic-maps.apk).

---

## 1. Included `.mwm` Map Packs (`260928/`)

| File | Approx. Size | Coverage |
| :--- | :---: | :--- |
| `World.mwm` | ~62 MB | Base world overview map (required by Organic Maps) |
| `WorldCoasts.mwm` | ~8 MB | World coastlines & Great Lakes boundaries (required) |
| **`Canada_Ontario_London.mwm`** | ~101 MB | **Chatham-Kent**, Windsor, Sarnia, London, St. Thomas, Lake St. Clair & north Lake Erie shore |
| `Canada_Ontario_Toronto.mwm` | ~157 MB | GTA, Hamilton, Niagara, Kitchener-Waterloo, Guelph |
| `Canada_Ontario_Bame.mwm` | ~75 MB | Barrie, Muskoka, Owen Sound, Bruce Peninsula |
| `Canada_Ontario_Kingston.mwm` | ~123 MB | Kingston, Ottawa, Eastern Ontario |
| `US_Michigan_Detroit.mwm` | ~147 MB | Metro Detroit & SE Michigan (across the Detroit/St. Clair rivers) |

To download or refresh these files:
```bash
./04_SCRIPTS/download-maps.sh
```

---

## 2. Using Offline Maps on Linux Laptop

1. **Launch Organic Maps Desktop:**
   ```bash
   flatpak run app.organicmaps.desktop
   ```
   The `.mwm` files are copied via Btrfs copy-on-write reflinks (`cp --reflink=auto`) into `~/.var/app/app.organicmaps.desktop/data/OrganicMaps/260928/` and `~/.var/app/app.organicmaps.desktop/data/OrganicMaps/261110/`, so local maps load immediately offline with zero extra disk usage and without needing Flatpak filesystem overrides.

2. **Installing on Another Air-Gapped Linux Machine:**
   A standalone offline Flatpak bundle is exported at `00_BOOTSTRAP/appimages/organic-maps-desktop.flatpak`:
   ```bash
   flatpak install --user -y ./00_BOOTSTRAP/appimages/organic-maps-desktop.flatpak
   mkdir -p ~/.var/app/app.organicmaps.desktop/data/OrganicMaps/{260928,261110}
   cp --reflink=auto -u ./01_KNOWLEDGE/maps_mwm/260928/*.mwm ~/.var/app/app.organicmaps.desktop/data/OrganicMaps/260928/
   cp --reflink=auto -u ./01_KNOWLEDGE/maps_mwm/260928/*.mwm ~/.var/app/app.organicmaps.desktop/data/OrganicMaps/261110/
   ```
   *(If a future desktop build uses a different map version folder name in `/app/share/organicmaps/data/countries.json`, populate that version directory inside `~/.var/app/app.organicmaps.desktop/data/OrganicMaps/` using `cp --reflink=auto` as well.)*

---

## 3. Sideloading to Mobile Devices (Offline)

- **Android (`00_BOOTSTRAP/apks/organic-maps.apk`):**
  1. Install `organic-maps.apk` and open it once so it initializes its data directory, then close it.
  2. Copy all `.mwm` files from `01_KNOWLEDGE/maps_mwm/260928/` into:
     `Internal Storage/Android/data/app.organicmaps/files/260928/`
     *(Or copy the `.mwm` files anywhere on the phone and open them directly via Organic Maps / your file manager to import.)*

- **iPhone / iPad:**
  1. Install **Organic Maps** from the App Store while online (or keep it pre-installed).
  2. Copy the `.mwm` files via USB / AirDrop / Files app into:
     `On My iPhone/Organic Maps/` (or tap the `.mwm` file in the Files app -> Share -> Organic Maps).
