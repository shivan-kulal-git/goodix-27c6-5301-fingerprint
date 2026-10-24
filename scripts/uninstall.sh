#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Run as root: sudo ./scripts/uninstall.sh"
    exit 1
fi

echo "Removing local libfprint override..."
rm -f /usr/local/lib/x86_64-linux-gnu/libfprint-2.so*
ldconfig
systemctl restart fprintd

echo "Done! System libfprint will be used."
