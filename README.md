# Blucode Rootfs (`Ubuntu 24.04 LTS`)

Prebuilt minimal **Ubuntu 24.04 (Noble)** PRoot rootfs images for **Blucode** (`arm64-v8a` & `x86_64`), including Node.js `v22.14.0`, Python 3, Git, `ripgrep`, `jq`, `curl`, and standard CLI tooling.

## Download Endpoints (`v1`)

Blucode downloads the rootfs automatically on first launch with resumable HTTP `Range` support and mandatory SHA-256 verification.

### Primary CDN (Cloudflare R2)
- **ARM64 (`arm64-v8a`)**: `https://rootfs.whalecoreai.com/v1/blucode-rootfs.tar.gz`

### Fallback Mirror (GitHub Releases — `v1`)
- **ARM64 (`arm64-v8a`)**: `https://github.com/whalecoredev/Blucode-rootfs/releases/download/v1/blucode-rootfs.tar.gz`
- **x86_64 (Emulator / x86)**: `https://github.com/whalecoredev/Blucode-rootfs/releases/download/v1/blucode-rootfs-x86.tar.gz`

## Checksums (`SHA-256`)

| File | Arch | Size (bytes) | SHA-256 |
|---|---|---:|---|
| `blucode-rootfs.tar.gz` | `arm64` (`aarch64`) | `139,231,064` | `fa7faf09f8ec53cf455303190c23054f5707fb9e5dee65da6f3987e9f0e8f840` |
| `blucode-rootfs-x86.tar.gz` | `amd64` (`x86_64`) | `134,709,970` | `73d1eecfb1493e6eb959e0f10d63864a0877c1977df8e64e0fbb678c6483990c` |

Verify locally:

```bash
sha256sum -c SHA256SUMS
```

## Rebuilding

- **ARM64**: `sudo ./build-rootfs.sh` (requires `debootstrap`, `qemu-user-static`, `binfmt-support`)
- **x86_64**: `sudo ./build-rootfs-x86.sh` (requires `debootstrap`)

Note: Large `.tar.gz` rootfs archives are hosted in GitHub Releases (`v1`) and Cloudflare R2, not tracked in Git history.
