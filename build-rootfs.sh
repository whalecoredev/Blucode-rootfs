#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

echo "=== [1/7] install tools ==="
apt-get install -y -qq debootstrap qemu-user-static binfmt-support >/dev/null 2>&1 || true

ROOT=/root/blucode-rootfs-build
rm -rf "$ROOT"

echo "=== [2/7] debootstrap arm64 ==="
debootstrap --arch=arm64 --foreign --variant=minbase noble "$ROOT" http://ports.ubuntu.com/ubuntu-ports

echo "=== [3/7] second stage via qemu ==="
cp /usr/bin/qemu-aarch64-static "$ROOT/usr/bin/"
chroot "$ROOT" /debootstrap/debootstrap --second-stage

echo "=== [4/7] apt sources ==="
cat > "$ROOT/etc/apt/sources.list" <<'EOF'
deb http://ports.ubuntu.com/ubuntu-ports noble main universe
deb http://ports.ubuntu.com/ubuntu-ports noble-updates main universe
deb http://ports.ubuntu.com/ubuntu-ports noble-security main universe
EOF
chroot "$ROOT" apt-get update -qq

echo "=== [5/7] install packages ==="
chroot "$ROOT" apt-get install -y -qq --no-install-recommends \
  ca-certificates curl git python3 python3-pip ripgrep jq unzip xz-utils less nano \
  bash coreutils findutils procps

echo "=== [6/7] node arm64 ==="
curl -sL https://nodejs.org/dist/v22.14.0/node-v22.14.0-linux-arm64.tar.xz -o /tmp/node-arm64.tar.xz
tar -xJf /tmp/node-arm64.tar.xz -C "$ROOT/usr/local" --strip-components=1

echo "=== [7/7] cleanup + pack ==="
chroot "$ROOT" apt-get clean
rm -rf "$ROOT/var/lib/apt/lists/"* "$ROOT/tmp/"* "$ROOT/usr/bin/qemu-aarch64-static" "$ROOT/var/cache/apt/archives/"*.deb
mkdir -p "$ROOT/workspace" "$ROOT/app"
printf 'nameserver 8.8.8.8\nnameserver 1.1.1.1\n' > "$ROOT/etc/resolv.conf"

tar -C "$ROOT" --numeric-owner -czf /root/blucode-rootfs.tar.gz .
ls -lh /root/blucode-rootfs.tar.gz
du -sh "$ROOT"
echo "=== DONE ==="
