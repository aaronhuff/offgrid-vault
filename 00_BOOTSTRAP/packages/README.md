# Air-Gapped Linux Package & Tooling Strategy

In a true off-grid or disaster recovery scenario, installing software on fresh Linux installations presents a classic catch-22: **Dependency Hell**. Downloading bare `.deb` or `.rpm` files fails because of unfulfilled transitive dependencies.

This directory and the off-grid vault solve this across three distinct defense tiers:

---

## Tier 1: Zero-Dependency Universal Static Binaries (Any Linux)
Located in `00_BOOTSTRAP/static_binaries/` and `00_BOOTSTRAP/tools/`.
These run immediately on **any** x86_64 Linux kernel (Ubuntu, Debian, Fedora, Arch, Alpine, Busybox live root) without installing `.deb` or `.rpm` packages and without containers.

1. **BusyBox (`busybox-x86_64`)**:
   - Single 2.2 MB static executable providing 300+ standard UNIX commands (`sh`, `vi`, `tar`, `awk`, `sed`, `wget`, `nc`, `ping`, `ip`, `traceroute`, etc.).
   - Make symlinks or run directly: `./busybox-x86_64 sh`.
2. **rclone (`rclone`)**:
   - Single static Go binary. Sync files across local disks, USBs, NFS, SMB, and S3 without any external libraries.
3. **llama.cpp (`00_BOOTSTRAP/tools/llama_cpp/`)**:
   - Standalone `llama-cli` and `llama-server`.
   - Run any GGUF quantized model (`llama3.2`, `qwen2.5-coder`, `moondream`) directly from the CLI or start an OpenAI-compatible web server on bare metal with zero Docker/Podman requirements:
     ```bash
     ./00_BOOTSTRAP/tools/llama_cpp/llama-cli -m ../../03_INTELLIGENCE/models_3b/Llama-3.2-1B-Instruct-Q4_K_M.gguf -p "Survival question here"
     ```

---

## Tier 2: Curated Offline `.deb` Bundle (`ubuntu_noble_core/`)
Located in `00_BOOTSTRAP/packages/ubuntu_noble_core/`.
Contains **172 pre-downloaded Debian packages** (~111 MB) with **100% of their transitive dependency tree** pre-resolved for Ubuntu 24.04 LTS (Noble Numbat).

### Included Tooling:
- **Compilers & Build**: `build-essential` (`gcc`, `g++`, `make`, `libc6-dev`, `binutils`, `dpkg-dev`)
- **Networking & VPN**: `wireguard-tools`, `curl`, `ca-certificates`, `openssh-client`
- **Operations & Multiplexing**: `tmux`, `htop`, `rsync`, `git`
- **Serial & Hardware**: `minicom`, `lrzsz` (for radio and serial debugging)
- **Scripting**: `python3-venv`, `python3-pip-whl`

### Air-Gapped Installation:
Plug the USB drive into a fresh offline Ubuntu 24.04 install and run:
```bash
cd 00_BOOTSTRAP/packages/ubuntu_noble_core
sudo ./INSTALL.sh
```
*(Or directly: `sudo dpkg -i *.deb`)*.

To re-fetch or update this bundle, run:
```bash
./04_SCRIPTS/download-offline-debs.sh
```

---

## Tier 3: Complete Offline APT Mirror (Debian 12 Full DVD-1)
For deep package availability (desktop environments, LibreOffice, GIMP, servers, database engines, etc.):

- **Debian Full DVD-1 ISO (`debian-12-DVD-1-amd64.iso`)**:
  - Downloaded via `./04_SCRIPTS/download-nas-horde.sh` (~3.7 GB).
  - Contains an entire local Debian repository with 10,000+ packages.
  - On an offline Debian machine, insert the USB or mount the ISO:
    ```bash
    sudo mount -o loop /path/to/debian-12-DVD-1-amd64.iso /media/cdrom
    sudo apt-cdrom add -m -d /media/cdrom
    sudo apt update
    sudo apt install <any-debian-package>
    ```
  - APT resolves dependencies automatically directly from the ISO file without touching the internet.
