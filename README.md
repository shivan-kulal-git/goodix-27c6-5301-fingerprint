# Goodix 27c6:5301 Fingerprint Driver for Ubuntu/Linux

I created this project to get the **Goodix USB fingerprint reader (`27c6:5301`) working on Ubuntu/Linux** through the `libfprint` and `fprintd` fingerprint authentication framework.

I started this project because I wanted to make this fingerprint reader usable on Linux. This repository contains my driver source code, prebuilt library files, installation and uninstallation scripts, and documentation to help others build, install, and test it.

> **Project status:** I have tested this driver on my own hardware. Your results may vary depending on your fingerprint reader, firmware, Linux distribution, kernel, and `libfprint` version. This is my community driver project and is not an official upstream `libfprint` driver.

## Features

- Driver implementation for the Goodix USB fingerprint reader `27c6:5301`.
- Integration intended for the Linux `libfprint` and `fprintd` framework.
- Prebuilt library and installation scripts for supported systems.
- Source-build instructions for users who prefer to build the driver themselves.
- Troubleshooting guidance to help diagnose common issues.

## Repository structure

- `src/goodix5301.c` — my driver source code.
- `src/goodix5301.h` — driver header.
- `drivers/` — prebuilt driver/library files, if included in the current checkout.
- `scripts/install.sh` — installation script.
- `scripts/uninstall.sh` — uninstallation script.
- `docs/BUILD.md` — source-build instructions.
- `docs/TESTING.md` — fingerprint enrollment and verification instructions.
- `docs/TESTED-HARDWARE.md` — hardware and software testing records.
- `docs/TROUBLESHOOTING.md` — troubleshooting guide.
- `QUICKSTART.md` — quick-start instructions.
- `DEPS.md` — dependency information.
- `LICENSE` — license information.

## Hardware information

The driver targets the following USB device:

| Property | Value |
|---|---|
| USB vendor ID | `27c6` |
| USB product ID | `5301` |
| USB ID | `27c6:5301` |
| Reported USB interfaces | CDC ACM and bulk data interfaces |
| Reported firmware string | `GF3208_HT_APP_10035` |
| Fingerprint framework | `libfprint` and `fprintd` |

These interface and firmware details are based on my investigation of the device. Other devices using the same USB ID may still behave differently.

## Installation

**Important:** Before installing the prebuilt library, check that it matches your Linux architecture and `libfprint` environment. The prebuilt version is intended for a compatible Linux `x86_64` system.

### 1. Check whether Linux detects the fingerprint reader

Connect the fingerprint reader and run:

```bash
lsusb -d 27c6:5301
```

If the device is detected, the output should include USB ID `27c6:5301`.

### 2. Clone my repository

```bash
git clone https://github.com/shivan-kulal-git/goodix-27c6-5301-fingerprint.git
cd goodix-27c6-5301-fingerprint
```

### 3. Review the installation script

Before running it with administrator privileges, inspect the script:

```bash
less scripts/install.sh
```

Check which files it installs, where it places the library, and whether it changes the dynamic linker configuration or restarts services.

### 4. Run the installer

If the script is suitable for your system, run:

```bash
sudo ./scripts/install.sh
```

The exact installation steps depend on the current version of the script in this repository.

### 5. Check the fingerprint service

```bash
systemctl status fprintd --no-pager
```

If the service is not running or the device is not detected, check the troubleshooting guide before changing system settings.

### 6. Enroll and verify your fingerprint

Enroll a fingerprint:

```bash
fprintd-enroll "$USER"
```

Verify it:

```bash
fprintd-verify "$USER"
```

If enrollment and verification succeed, the driver is communicating with the fingerprint framework successfully.

However, this does not automatically enable fingerprint authentication for the login screen or `sudo`. Those require separate system authentication configuration.

See [`docs/TESTING.md`](docs/TESTING.md) for more details.

## Building from source

I have included source code and build documentation for users who want to integrate the driver into a compatible `libfprint` source tree.

Start by reading [`docs/BUILD.md`](docs/BUILD.md).

A typical Ubuntu dependency installation may begin with:

```bash
sudo apt update
sudo apt install git build-essential meson ninja-build pkg-config \
  libusb-1.0-0-dev libglib2.0-dev libgusb-dev libnss3-dev \
  gtk-doc-tools
```

Clone the upstream `libfprint` source:

```bash
git clone https://gitlab.freedesktop.org/libfprint/libfprint.git
cd libfprint
```

Follow the build guide for the required source integration and driver registration.

> **Note:** The required integration changes and Meson options depend on the `libfprint` version. Do not assume that `meson setup builddir -Ddrivers=goodix5301` works with every version. Copying the driver source files alone does not necessarily register or compile the driver.

For reproducible builds, record the exact `libfprint` release or Git commit used.

## Fingerprint login and sudo

Getting fingerprint enrollment and verification working is only part of the setup. Enabling fingerprint authentication for login or `sudo` requires appropriate PAM configuration.

On Ubuntu, you can inspect available authentication profiles using:

```bash
sudo pam-auth-update
```

The available profiles depend on your installed packages and system configuration.

**Keep password authentication enabled as a fallback.** I recommend testing enrollment, verification, login, and `sudo` separately. Incorrect PAM changes can prevent normal authentication, so make sure you have another way to access your system before changing these settings.

## Troubleshooting

If the reader is not detected or fingerprint enrollment fails, collect the following information:

```bash
lsusb -d 27c6:5301
lsusb -t
systemctl status fprintd --no-pager
journalctl -u fprintd -b --no-pager
```

For more troubleshooting steps, see [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md).

Common problems may involve:

- The fingerprint reader not appearing in `lsusb`.
- `fprintd` reporting that no devices are available.
- An incompatible or incorrectly installed shared library.
- Driver registration or build errors.
- Fingerprint enrollment or verification failures.
- PAM configuration issues.

Please do not publish fingerprint images, templates, passwords, or other sensitive authentication information when reporting issues.

## Uninstallation

I have included an uninstallation script in the repository. Before running it, inspect its behavior:

```bash
less scripts/uninstall.sh
```

Follow the procedure documented for the version you installed. Check which files and settings the script removes or restores rather than assuming that it automatically reverses every system change.

## Tested hardware

I have tested the driver on my own hardware. I am documenting the exact system configuration and test results in [`docs/TESTED-HARDWARE.md`](docs/TESTED-HARDWARE.md).

When reporting compatibility, I recommend recording the computer model, USB ID, Ubuntu release, kernel version, architecture, `libfprint` revision, and actual enrollment and verification results.

I do not consider another machine or software configuration supported merely because it uses the same USB ID.

## Upstream status

This is my independent, community-maintained driver project. It is not officially supported by upstream `libfprint` unless the relevant changes are accepted into the upstream project.

If you find a problem or successfully test the driver on another configuration, feel free to open an issue with the relevant technical details.

## License and attribution

This repository declares **LGPL-2.1**. Please see the [`LICENSE`](LICENSE) file for the applicable terms.

I aim to preserve the relevant licensing information and attribution for the code distributed in this repository. Before redistributing modified libraries or prebuilt binaries, check the applicable license requirements and ensure the corresponding source and notices are provided where required.

## Contributing

If you test the driver on another machine or distribution, I welcome useful compatibility reports and technical contributions.

When opening an issue, please include:

- Computer model and fingerprint reader USB ID.
- Linux distribution and kernel version.
- `libfprint` version or Git commit.
- Relevant error messages and service logs.
- Whether enrollment and verification succeeded.
- Whether login or `sudo` authentication was tested separately.

Please remove personal information and never attach biometric data.

---

**Repository:** [goodix-27c6-5301-fingerprint](https://github.com/shivan-kulal-git/goodix-27c6-5301-fingerprint)

**Maintained by:** [shivan-kulal-git](https://github.com/shivan-kulal-git)
