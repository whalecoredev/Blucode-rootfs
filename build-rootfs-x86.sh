#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
ROOT=/root/blucode-rootfs-x86
rm -rf "$ROOT"
echo "=== debootstrap amd64 ==="
debootstrap --arch=amd64 --variant=minbase noble "$ROOT" http://archive.ubuntu.com/ubuntu > /dev/null 2>&1
cat > "$ROOT/etc/apt/sources.list" <<'EOF'
deb http://archive.ubuntu.com/ubuntu noble main universe
deb http://archive.ubuntu.com/ubuntu noble-updates main universe
EOF
echo "=== install packages ==="
chroot "$ROOT" apt-get update -qq
chroot "$ROOT" apt-get install -y -qq --no-install-recommends \
  ca-certificates curl git python3 ripgrep jq unzip xz-utils less nano bash coreutils findutils procps > /dev/null 2>&1
echo "=== node amd64 ==="
curl -sL https://nodejs.org/dist/v22.14.0/node-v22.14.0-linux-x64.tar.xz -o /tmp/node-x64.tar.xz
tar -xJf /tmp/node-x64.tar.xz -C "$ROOT/usr/local" --strip-components=1
chown -R 0:0 "$ROOT/usr/local"
chmod -R a+rX "$ROOT/usr/local"
echo "=== cleanup ==="
chroot "$ROOT" apt-get clean
rm -rf "$ROOT/var/lib/apt/lists/"* "$ROOT/tmp/"* "$ROOT/var/cache/apt/archives/"*.deb
rm -rf "$ROOT/proc" "$ROOT/sys" "$ROOT/dev"
mkdir -p "$ROOT/proc" "$ROOT/sys" "$ROOT/dev" "$ROOT/workspace" "$ROOT/app"
printf 'nameserver 8.8.8.8\nnameserver 1.1.1.1\n' > "$ROOT/etc/resolv.conf"
echo "=== pack ==="
tar --numeric-owner -czf /root/blucode-rootfs-x86.tar.gz -C "$ROOT" .
ls -lh /root/blucode-rootfs-x86.tar.gz
echo "DONE"
