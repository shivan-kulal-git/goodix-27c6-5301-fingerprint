#!/bin/bash
echo "Checking dependencies..."
for pkg in fprintd libfprint-2-2; do
    if dpkg -l | grep -q "^ii  $pkg "; then
        echo "OK: $pkg"
    else
        echo "MISSING: $pkg"
    fi
done
echo "Done."
