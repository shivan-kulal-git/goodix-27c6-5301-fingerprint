#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Run as root: sudo ./scripts/install.sh"
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing Goodix 27c6:5301 libfprint driver..."
cp "$DIR/drivers/libfprint-2.so.2.0.0" /usr/local/lib/x86_64-linux-gnu/
ln -sf libfprint-2.so.2.0.0 /usr/local/lib/x86_64-linux-gnu/libfprint-2.so.2
ln -sf libfprint-2.so.2.0.0 /usr/local/lib/x86_64-linux-gnu/libfprint-2.so

# Ensure local lib path is configured
if [ ! -f /etc/ld.so.conf.d/libfprint-local.conf ]; then
    echo "/usr/local/lib/x86_64-linux-gnu" > /etc/ld.so.conf.d/libfprint-local.conf
fi

ldconfig
systemctl restart fprintd

echo "Done! Check with: fprintd-list \$USER"
