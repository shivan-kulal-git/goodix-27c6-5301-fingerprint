# Goodix 27c6:5301 Fingerprint Driver for Ubuntu/Linux

A community driver project for the **Goodix USB fingerprint reader `27c6:5301`**, intended to integrate with Linux `libfprint` and `fprintd`.

This repository contains driver source, prebuilt library files, installation and uninstall scripts, and build documentation.

> **Status:** The project author reports this driver working on their hardware. Compatibility with other machines and software configurations should be verified separately. This is not an official upstream `libfprint` driver unless and until it is accepted upstream.

## Contents

- `src/goodix5301.c` and `src/goodix5301.h` — driver source.
- `drivers/` — prebuilt driver/library files, if included in this checkout.
- `scripts/install.sh` — installation script.
- `scripts/uninstall.sh` — uninstall script.
- `docs/BUILD.md` — source-build instructions, if included.
- `docs/TROUBLESHOOTING.md` — diagnostic commands and common issues.
- `docs/TESTED-HARDWARE.md` — a template for recording verified configurations.

Check that these paths match the files in the current repository.

## Hardware

| Property | Value |
|---|---|
| USB vendor ID | `27c6` |
| USB product ID | `5301` |
| USB ID | `27c6:5301` |
| Reported interfaces | CDC ACM and bulk data interfaces |
| Reported firmware string | `GF3208_HT_APP_10035` |
| Framework | `libfprint` / `fprintd` |

Some ASUS and Dell models may use this USB ID, but the same ID alone does not guarantee that every model or firmware revision will work.

## Tested configuration

See [`docs/TESTED-HARDWARE.md`](docs/TESTED-HARDWARE.md). Record exact results from hardware you personally tested. Do not treat an untested model, Ubuntu release, kernel, or `libfprint` version as supported merely because it is listed as potentially compatible.

## Safety and compatibility

- The prebuilt library is intended for a compatible **Linux x86_64** environment. Do not install it on a different architecture unless you have built and tested an appropriate version.
- Compatibility depends on the `libfprint` version, build options, distribution packaging, and driver integration—not only the Linux kernel version.
- The installer uses administrator privileges and may modify system library files or service state. Read `scripts/install.sh` before running it.
- Keep password authentication available and ensure you have another way to access your machine before changing PAM/login configuration.
- Review `scripts/uninstall.sh` before using it. Its exact rollback behavior depends on the implementation in this repository.
- Do not upload fingerprint images, templates, or other biometric data to public issues.

## Quick install (prebuilt library)

### 1. Check the device

```bash
lsusb -d 27c6:5301
```

Confirm that the expected fingerprint reader appears.

### 2. Clone the repository

```bash
git clone https://github.com/shivan-kulal-git/goodix-27c6-5301-fingerprint.git
cd goodix-27c6-5301-fingerprint
```

### 3. Review and run the installer

```bash
less scripts/install.sh
sudo ./scripts/install.sh
```

The project documentation describes the installer as placing a library under `/usr/local/lib/x86_64-linux-gnu/`, updating the dynamic linker cache, and restarting `fprintd`. Confirm these actions in the current script before proceeding.

### 4. Enroll and verify

```bash
fprintd-enroll "$USER"
fprintd-verify "$USER"
```

Successful verification confirms fingerprint matching works. It does **not** by itself confirm that login or `sudo` authentication has been enabled.

## Enable login or sudo authentication

Configure fingerprint authentication using the supported settings for your distribution. On Ubuntu, `sudo pam-auth-update` may show available PAM profiles:

```bash
sudo pam-auth-update
```

The available options depend on installed packages and system configuration. Keep password authentication enabled as a fallback, and test login and `sudo` separately. Do not manually edit PAM files unless you understand how to recover if authentication fails.

## Build from source

The driver must be integrated into a compatible `libfprint` source tree. The exact integration changes and Meson options vary by source version.

Install the dependencies listed by your build guide. A typical Ubuntu starting point is:

```bash
sudo apt update
sudo apt install git build-essential meson ninja-build pkg-config \
  libusb-1.0-0-dev libglib2.0-dev libgusb-dev libnss3-dev \
  gtk-doc-tools
```

Clone upstream `libfprint`:

```bash
git clone https://gitlab.freedesktop.org/libfprint/libfprint.git
cd libfprint
```

Follow [`docs/BUILD.md`](docs/BUILD.md) in this repository for the required driver registration, source integration, and build options.

**Do not assume** that `meson setup builddir -Ddrivers=goodix5301` works with every `libfprint` version. Use that command only if the selected source tree's Meson configuration registers `goodix5301` and accepts that option. Copying the `.c` and `.h` files alone does not necessarily register or compile the driver.

For reproducibility, document the exact upstream `libfprint` release or Git commit and any patches used to build the prebuilt library.

## USB interface notes

The project reports that the reader uses CDC ACM and bulk data interfaces, and that `cdc_acm` may need to be detached temporarily while the sensor is in use. The driver is intended to handle this behavior.

If the device is not detected, collect diagnostics:

```bash
lsusb -d 27c6:5301
systemctl status fprintd --no-pager
journalctl -u fprintd -b --no-pager
```

Do not manually detach USB interfaces unless the driver documentation specifically calls for it.

## Uninstallation

The repository includes `scripts/uninstall.sh`. Inspect it first:

```bash
less scripts/uninstall.sh
```

Then follow the repository's documented uninstall procedure. Confirm what the script removes or restores before running it.

## Troubleshooting

See [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) for diagnostic commands and common failure cases.

## Upstream status

This is a community-maintained driver project. Do not describe it as officially supported by upstream `libfprint` unless a corresponding upstream change has been accepted. If this implementation adapts code from another project, identify the original source and preserve the required notices and license terms.

## License and attribution

The repository currently declares **LGPL-2.1-or-later**. Confirm that this license and its notices are appropriate for every file distributed here, including any prebuilt library. If the binary is built from a modified LGPL-covered `libfprint`, follow the applicable requirements for distributing modified library binaries and corresponding source. Preserve notices and attribution for any code adapted from other projects.

Include a complete `LICENSE` file in the repository if it is not already present. Do not add a license file with guessed or incomplete text.
