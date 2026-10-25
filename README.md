# Goodix 27c6:5301 Fingerprint Driver for Ubuntu/Linux

A community driver implementation for the **Goodix `27c6:5301` fingerprint reader**, designed to work with the Linux `libfprint` and `fprintd` fingerprint authentication stack.

This repository contains the driver source code, prebuilt library, installation and uninstall scripts, and instructions for building from source.

## Hardware Compatibility

| Property | Details |
|---|---|
| USB Vendor ID | `27c6` |
| USB Product ID | `5301` |
| USB ID | `27c6:5301` |
| USB Interfaces | CDC ACM and bulk data interfaces |
| Kernel Interface | `cdc_acm` |
| Firmware String | `GF3208_HT_APP_10035` |
| Fingerprint Framework | `libfprint` / `fprintd` |

The reader is found in certain laptop models, including some ASUS and Dell devices. A matching USB ID does not guarantee compatibility with every device.

### Tested Environment

- Ubuntu 24.04
- Linux kernel 6.8 or later
- x86_64 systems

Other distribution versions and hardware configurations may require additional testing.

## Repository Contents

- `src/goodix5301.c` — fingerprint driver implementation.
- `src/goodix5301.h` — driver header.
- `drivers/` — prebuilt library files.
- `scripts/install.sh` — installation script.
- `scripts/uninstall.sh` — uninstall script.
- `docs/BUILD.md` — source-build instructions, if included in the repository.

## Quick Install — Prebuilt Library

### 1. Check Your Fingerprint Reader

Connect your device and run:

```bash
lsusb -d 27c6:5301
```

Confirm that the output identifies your fingerprint reader.

### 2. Clone the Repository

```bash
git clone https://github.com/shivan-kulal-git/goodix-27c6-5301-fingerprint.git
cd goodix-27c6-5301-fingerprint
```

### 3. Install the Driver

Review the installation script before executing it with administrator privileges:

```bash
less scripts/install.sh
```

Install the driver:

```bash
sudo ./scripts/install.sh
```

The installer is intended to install the prebuilt library under:

`/usr/local/lib/x86_64-linux-gnu/`

It also updates the dynamic linker cache and restarts the fingerprint service, as described by the project.

### 4. Enroll Your Fingerprint

After installation, enroll a fingerprint for your current user:

```bash
fprintd-enroll "$USER"
```

Follow the on-screen instructions to scan your finger.

### 5. Verify Fingerprint Recognition

```bash
fprintd-verify "$USER"
```

Successful verification confirms that fingerprint recognition is working.

## Enable Fingerprint Login

After enrollment and verification, configure fingerprint authentication through your distribution's supported settings or PAM configuration.

On Ubuntu, you can inspect available authentication modules with:

```bash
sudo pam-auth-update
```

The available options depend on the installed packages and system configuration.

Keep password authentication available as a fallback, and test login and `sudo` authentication separately.

## Build from Source

The driver can be integrated into a compatible `libfprint` source tree.

### 1. Install Build Dependencies

```bash
sudo apt update
sudo apt install git build-essential meson ninja-build pkg-config \
  libusb-1.0-0-dev libglib2.0-dev libgusb-dev libnss3-dev \
  gtk-doc-tools
```

### 2. Clone the libfprint Repository

```bash
git clone https://gitlab.freedesktop.org/libfprint/libfprint.git
cd libfprint
```

### 3. Add the Driver Source

Copy the driver files into the appropriate driver directory in the source tree:

```bash
cp ../src/goodix5301.c libfprint/drivers/
cp ../src/goodix5301.h libfprint/drivers/
```

**Important:** The commands above assume the `src` directory is available at the relative path shown. Adjust the paths if your directory layout differs.

### 4. Configure the Build

Register the driver in the relevant Meson build files as described in `docs/BUILD.md`.

Then configure and build using the Meson options supported by your selected `libfprint` version.

```bash
meson setup builddir -Ddrivers=goodix5301
ninja -C builddir
sudo ninja -C builddir install
```

The Meson option above must match the actual driver registration and build configuration. Refer to the project's build documentation if the option is not recognized.

## USB Interface Notes

The sensor uses CDC ACM and bulk data interfaces.

The driver documentation indicates that the `cdc_acm` kernel driver may need to be detached temporarily during sensor operation. The driver is intended to handle this behavior.

If the device is not detected, collect diagnostic information:

```bash
lsusb -d 27c6:5301
systemctl status fprintd --no-pager
journalctl -u fprintd -b --no-pager
```

## Uninstallation

The repository includes an uninstall script.

Review its contents before running it:

```bash
less scripts/uninstall.sh
```

If you need to remove the custom driver installation, run the script according to the repository's documented procedure:

```bash
sudo ./scripts/uninstall.sh
```

## Troubleshooting

### Fingerprint device not detected

Check the USB ID:

```bash
lsusb -d 27c6:5301
```

### Fingerprint service errors

```bash
systemctl status fprintd --no-pager
journalctl -u fprintd -b --no-pager
```

### Enrollment or verification fails

- Confirm that the expected sensor is connected.
- Check that the driver library is installed in the intended location.
- Restart the fingerprint service.
- Review the service logs for errors.

## Contributing

Bug reports and contributions are welcome.

When reporting an issue, include:

- Laptop model.
- Linux distribution and version.
- Kernel version.
- USB ID.
- Relevant `fprintd` logs.
- Whether enrollment and verification work.

Do not upload fingerprint images, biometric templates, or other sensitive biometric data to public issues.

## License

This project declares **LGPL-2.1-or-later**, following the licensing approach of `libfprint`.

Review the applicable license and attribution requirements for the driver source and any distributed prebuilt library.

## Acknowledgments

This project builds on the Linux fingerprint ecosystem, including `libfprint` and `fprintd`.

Thanks to the open-source developers and Linux community members working to improve fingerprint support for unsupported hardware.
