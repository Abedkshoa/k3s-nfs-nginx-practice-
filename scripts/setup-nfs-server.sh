#!/bin/bash

# This script must be run as root or with sudo
set -e

SHARE_DIR="/srv/nfs/k3s-share"
EXPORTS_LINE="$SHARE_DIR *(rw,sync,no_subtree_check,no_root_squash)"

echo "[INFO] Installing NFS server..."
apt update && apt install -y nfs-kernel-server

echo "[INFO] Creating shared directory at $SHARE_DIR..."
mkdir -p "$SHARE_DIR"
chown nobody:nogroup "$SHARE_DIR"
chmod 777 "$SHARE_DIR"

echo "[INFO] Creating index.html in shared folder..."
echo "NFS StorageClass To Container" > "$SHARE_DIR/index.html"

echo "[INFO] Updating /etc/exports..."
if ! grep -Fxq "$EXPORTS_LINE" /etc/exports; then
    echo "$EXPORTS_LINE" >> /etc/exports
else
    echo "[INFO] Export already exists in /etc/exports."
fi

echo "[INFO] Applying exports..."
exportfs -rav

echo "[INFO] Restarting NFS server..."
systemctl restart nfs-kernel-server

echo "[DONE] NFS server is configured and running."
