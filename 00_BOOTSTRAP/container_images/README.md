# Air-Gapped Container Architecture & Offline Registry

In an off-grid scenario, standard container workflows (`docker pull`, `podman run`) immediately break because public registries (`docker.io`, `ghcr.io`, `quay.io`) are unreachable.

This directory provides a **zero-internet container runtime kit**:

---

## 1. Pre-Packaged Offline Image Archives (`.tar.gz`)
These compressed tarballs contain pre-built container images ready to import in seconds onto any offline system:

| Archive | Source Image | Size | Role in Disaster Recovery |
|---|---|:---:|---|
| **`kiwix-serve.tar.gz`** | `ghcr.io/kiwix/kiwix-serve:latest` | ~25 MB | **Camp Knowledge Server**: Broadcasts offline `.zim` files (Wikipedia, WikiMed, Appropedia) over HTTP on port 8080 so anyone on Wi-Fi can browse without apps. |
| **`registry-v2.tar.gz`** | `docker.io/library/registry:2` | ~24 MB | **Air-Gapped Container Registry**: Runs on port 5000 to distribute images to all nodes on the local LAN. |
| **`caddy-alpine.tar.gz`** | `docker.io/library/caddy:alpine` | ~24 MB | **Reverse Proxy & Web Server**: Serves the Civilian Seed Pack, HTML manuals, and local sites with automatic internal HTTPS. |
| **`ubuntu-noble.tar.gz`** | `docker.io/library/ubuntu:noble` | ~28 MB | **Build & Recovery Sandbox**: Pre-configured Ubuntu 24.04 environment for compiling software and running scripts. |
| **`alpine.tar.gz`** | `docker.io/library/alpine:latest` | ~4 MB | **Micro Utility Container**: Instant lightweight shell, DNS, and networking tools. |

---

## 2. One-Command Offline Import
To load all container images onto a brand-new offline computer:
```bash
cd 00_BOOTSTRAP/container_images
./IMPORT_ALL.sh
```
*(Automatically detects whether you are running `podman` or `docker` and loads all images).*

---

## 3. Running the Local Air-Gapped Docker Registry (Port 5000)
To establish your own private container registry on the local network so other machines (Pi, laptops, VMs) can pull containers:
```bash
./run-offline-registry.sh
```
- Listens on `0.0.0.0:5000`.
- To push an image:
  ```bash
  podman tag my-image:latest localhost:5000/my-image:latest
  podman push localhost:5000/my-image:latest
  ```
- Any machine on the LAN can now pull:
  ```bash
  podman pull --tls-verify=false 10.1.1.10:5000/my-image:latest
  ```

---

## 4. Broadcasting Wikipedia & Survival Manuals Over Wi-Fi (Port 8080)
To turn your laptop, Raspberry Pi, or server into a local Wi-Fi knowledge hotspot:
```bash
./run-kiwix-server.sh [path-to-zim-folder]
```
Any phone, tablet, or laptop on the Wi-Fi can open a web browser and navigate to:
`http://<SERVER-IP>:8080`
to browse full offline Wikipedia, medical manuals, and survival articles with zero client configuration.
