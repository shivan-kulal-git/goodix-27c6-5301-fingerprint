# Building from source

1. Install dependencies:
```bash
sudo apt install build-essential meson ninja-build pkg-config libusb-1.0-0-dev \
  libglib2.0-dev libgusb-dev libnss3-dev gtk-doc-tools libsystemd-dev
```

2. Clone libfprint:
```bash
git clone https://gitlab.freedesktop.org/libfprint/libfprint.git
cd libfprint
```

3. Copy driver files:
```bash
cp /path/to/src/goodix5301.c libfprint/drivers/
cp /path/to/src/goodix5301.h libfprint/drivers/
```

4. Add to meson.build in `libfprint/meson.build`:
```meson
    'goodix5301' : files('drivers/goodix5301.c'),
```

5. Build and install:
```bash
meson setup builddir -Ddrivers=goodix5301
ninja -C builddir
sudo ninja -C builddir install
```

6. Update linker cache and restart fprintd:
```bash
sudo ldconfig
sudo systemctl restart fprintd
```
