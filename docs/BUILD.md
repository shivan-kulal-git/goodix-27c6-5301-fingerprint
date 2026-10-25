# Building from Source

The exact integration steps depend on the `libfprint` revision. Use the release or Git commit known to work with this driver and record it in `TESTED-HARDWARE.md`.

## 1. Install dependencies

```bash
sudo apt update
sudo apt install git build-essential meson ninja-build pkg-config \
  libusb-1.0-0-dev libglib2.0-dev libgusb-dev libnss3-dev \
  gtk-doc-tools libsystemd-dev
```

## 2. Clone libfprint

```bash
git clone https://gitlab.freedesktop.org/libfprint/libfprint.git
cd libfprint
```

For reproducibility, check out the exact release or commit that you tested.

## 3. Copy the driver files

Replace `/absolute/path/to/goodix-27c6-5301-fingerprint` with the actual absolute path to this repository:

```bash
cp /absolute/path/to/goodix-27c6-5301-fingerprint/src/goodix5301.c libfprint/drivers/
cp /absolute/path/to/goodix-27c6-5301-fingerprint/src/goodix5301.h libfprint/drivers/
```

Copying the files alone does not register or compile the driver.

## 4. Register the driver

Inspect the selected `libfprint` revision's existing driver declarations and Meson configuration. Integrate `goodix5301` using the pattern for other drivers in that revision. Additional registration or source changes may be required.

The following line from the original instructions is an example, not a universal patch:

```meson
'goodix5301' : files('drivers/goodix5301.c'),
```

Do not paste it into an arbitrary location. Check the surrounding Meson structure, source paths, driver-selection mechanism, and any required registration code.

## 5. Configure and build

The original project instructions use:

```bash
meson setup builddir -Ddrivers=goodix5301
ninja -C builddir
```

Use this option only if the selected `libfprint` revision defines the `drivers` option and recognizes `goodix5301`. If Meson reports an unknown option or driver, check that revision's build files; do not assume this command works for all versions.

Confirm the driver was included in the build before installing.

## 6. Install

```bash
sudo ninja -C builddir install
sudo ldconfig
sudo systemctl restart fprintd
```

Installing a custom `libfprint` build may affect the system fingerprint stack. Keep password access available and understand your recovery options before changing authentication settings.

Record the exact `libfprint` commit, build options, distribution, kernel, architecture, and test results in `TESTED-HARDWARE.md`.
