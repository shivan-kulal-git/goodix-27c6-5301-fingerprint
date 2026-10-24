# Goodix 27c6:5301 Fingerprint Driver for Ubuntu/Linux

This repository provides a working libfprint driver for the **Goodix 27c6:5301** fingerprint reader (found in devices like ASUS ZenBook S UX391UA and similar Dell/ASUS models).

## Hardware compatibility
- USB ID: `27c6:5301`
- Tested on Ubuntu 24.04/26.04 (kernel 6.8+)
- Uses CDC ACM + bulk data interfaces (cdc_acm kernel driver)

## What this includes
- `src/goodix5301.c`, `src/goodix5301.h` - Driver source for libfprint
- `drivers/` - Pre-built libfprint library with the goodix5301 driver
- `scripts/install.sh` - Installation script
- `scripts/uninstall.sh` - Rollback script

## Quick install (pre-built)
```bash
sudo ./scripts/install.sh
```

This will install the library to `/usr/local/lib/x86_64-linux-gnu/`, update ldconfig, and restart fprintd.

After installation:
1. Open Settings > Users > Fingerprint Login (or equivalent) to enroll
2. Or use `fprintd-enroll`

## Build from source
```bash
# Install build deps
sudo apt install build-essential meson ninja-build pkg-config libusb-1.0-0-dev \
  libglib2.0-dev libgusb-dev libnss3-dev gtk-doc-tools

# Clone libfprint and apply driver
git clone https://gitlab.freedesktop.org/libfprint/libfprint.git
cd libfprint
cp ../src/goodix5301.c libfprint/drivers/
cp ../src/goodix5301.h libfprint/drivers/

# Add to meson.build (see docs/BUILD.md)
# Then build
meson setup builddir -Ddrivers=goodix5301
ninja -C builddir
sudo ninja -C builddir install
```

## Notes
- The sensor requires the `cdc_acm` driver to be temporarily detached during operation (handled by the driver)
- Firmware string `GF3208_HT_APP_10035` is supported
- Works with fprintd for login/enrollment/verification

## License
LGPL-2.1-or-later (same as libfprint)
