# Goodix 27c6:5301 Fingerprint Driver for Ubuntu/Linux

A community driver project for the **Goodix USB fingerprint reader `27c6:5301`**, intended to integrate with Linux `libfprint` and `fprintd`.

This repository contains driver source code, prebuilt library files, installation and uninstallation scripts, and documentation for building, testing, and troubleshooting the driver.

> [!IMPORTANT]
> **Compatibility is not guaranteed.** The project author reports that the driver works on their hardware. Other machines, firmware revisions, Linux distributions, and `libfprint` versions must be tested separately.
>
> This is a community-maintained project and is **not an official upstream `libfprint` driver** unless and until the relevant changes are accepted upstream.

## Contents

- `src/goodix5301.c` — driver source code.
- `src/goodix5301.h` — driver header.
- `drivers/` — prebuilt driver/library files, if included in the current checkout.
- `scripts/install.sh` — installation script.
- `scripts/uninstall.sh` — uninstallation script.
- `docs/BUILD.md` — source-build instructions.
- `docs/TESTING.md` — enrollment and verification procedures.
- `docs/TESTED-HARDWARE.md` — tested hardware and software configurations.
- `docs/TROUBLESHOOTING.md` — diagnostic commands and troubleshooting guidance.
- `QUICKSTART.md` — quick-start instructions.
- `DEPS.md` — dependency information.
- `LICENSE` — repository license.

Check the repository for the current file names and paths before following individual instructions.

## Hardware information

| Property | Reported value |
|---|---|
| USB vendor ID | `27c6` |
| USB product ID | `5301` |
| USB ID | `27c6:5301` |
| USB interfaces | CDC ACM and bulk data interfaces |
| Reported firmware string | `GF3208_HT_APP_10035` |
| Linux fingerprint framework | `libfprint` and `fprintd` |

The USB interface and firmware details are project-reported information and should be verified against the actual device when diagnosing compatibility.

Some ASUS and Dell computers may use this USB ID. However, matching USB IDs alone do not guarantee compatibility across all models or firmware revisions.

## Compatibility and safety

Before installing the driver, keep the following in mind:

- **Architecture:** The prebuilt library is intended for a compatible Linux `x86_64` environment. Do not install it on another architecture unless you have built and tested a suitable version.
- **`libfprint` compatibility:** Compatibility depends on the exact `libfprint` version, its build configuration, the distribution's packaging, and the driver's integration.
- **Kernel compatibility:** A sufficiently recent kernel alone does not guarantee that the driver will work.
- **Administrator privileges:** The installation script may modify system library files, linker configuration, or service state. Inspect it before execution.
- **Authentication recovery:** Keep password authentication available and ensure you have an alternative way to access your computer before changing PAM or login settings.
- **Uninstallation:** Inspect the uninstallation script to understand which files and settings it removes or restores.
- **Biometric privacy:** Do not publish fingerprint images, templates, or other sensitive biometric data in public issues.

## Installation using the prebuilt library

These instructions assume that the repository includes a compatible prebuilt library and that the installation script supports your system.

### 1. Check whether the fingerprint reader is detected

Open a terminal and run:

```bash
lsusb -d 27c6:5301
```

If the device is detected, the output should contain a USB device with ID `27c6:5301`.

If no output appears, check the USB connection and confirm the device's actual USB ID.

### 2. Clone the repository

```bash
git clone https://github.com/shivan-kulal-git/goodix-27c6-5301-fingerprint.git
cd goodix-27c6-5301-fingerprint
```

### 3. Inspect the installation script

Before running commands with administrator privileges, review the script:

```bash
less scripts/install.sh
```

Check the target library directory, architecture assumptions, dependency checks, and any service or linker-cache changes.

### 4. Run the installer

If the script is appropriate for your system, run:

```bash
sudo ./scripts/install.sh
```

The expected installation behavior should be confirmed by inspecting the current script. Do not assume that every repository version installs the same files or performs the same actions.

### 5. Restart and check the fingerprint service

If the installation procedure requires restarting `fprintd`, follow the script's documented instructions. You can inspect the service with:

```bash
systemctl status fprintd --no-pager
```

### 6. Enroll and verify a fingerprint

Run:

```bash
fprintd-enroll "$USER"
```

Then verify the enrolled fingerprint:

```bash
fprintd-verify "$USER"
```

A successful verification demonstrates that fingerprint matching works through the configured fingerprint stack. It does **not** automatically prove that fingerprint login, lock-screen authentication, or `sudo` authentication is enabled.

For more detailed steps, see [`docs/TESTING.md`](docs/TESTING.md).

## Enable fingerprint login or sudo authentication

Fingerprint enrollment and system authentication are separate tasks.

On Ubuntu, you can inspect the available PAM authentication profiles with:

```bash
sudo pam-auth-update
```

Available options depend on the installed packages and system configuration. Do not assume that a fingerprint profile is available simply because the driver has been installed.

**Important precautions:**

- Keep password authentication enabled as a fallback.
- Do not manually edit PAM configuration unless you understand the recovery procedure.
- Test fingerprint login and `sudo` authentication separately.
- Ensure you can access the system through another account or recovery method before making authentication changes.

Consult your distribution's documentation for supported PAM configuration procedures.

## Build from source

Building from source may be necessary if the prebuilt library is incompatible with your installed `libfprint` version.

The driver must be integrated into a compatible `libfprint` source tree. The exact source changes, driver registration, and Meson build options depend on the selected upstream version.

Start with the build instructions in [`docs/BUILD.md`](docs/BUILD.md).

A typical Ubuntu dependency installation may begin with:

```bash
sudo apt update
sudo apt install git build-essential meson ninja-build pkg-config \
  libusb-1.0-0-dev libglib2.0-dev libgusb-dev libnss3-dev \
  gtk-doc-tools
```

The exact dependency list may differ by `libfprint` version and build configuration.

Clone the upstream source:

```bash
git clone https://gitlab.freedesktop.org/libfprint/libfprint.git
cd libfprint
```

Follow the integration instructions in this repository for the selected source revision.

> [!WARNING]
> Do not assume that `meson setup builddir -Ddrivers=goodix5301` works with every `libfprint` version. Use a Meson option only if the selected source tree registers the driver and accepts that option. Copying the driver source files alone does not necessarily register or compile the driver.

For reproducible builds, record:

- The exact `libfprint` release or Git commit.
- The patches and source changes applied.
- The Meson configuration and enabled drivers.
- The build architecture and distribution.
- The test results on the target hardware.

## USB interface notes

The project reports that the device uses CDC ACM and bulk data interfaces. The `cdc_acm` kernel driver may interact with the device's interfaces.

If the reader is not detected or cannot be opened, collect diagnostic information before changing USB driver bindings.

```bash
lsusb -d 27c6:5301
lsusb -t
systemctl status fprintd --no-pager
journalctl -u fprintd -b --no-pager
```

Do not manually detach USB interfaces or stop kernel drivers unless the driver documentation specifically requires it and you understand how to restore the original configuration.

## Troubleshooting

For detailed diagnostic commands and common failure scenarios, see [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md).

Common areas to investigate include:

- The fingerprint reader not appearing in `lsusb`.
- `fprintd` reporting that no devices are available.
- An incompatible or incorrectly installed shared library.
- Driver registration or build failures.
- Fingerprint enrollment or verification errors.
- PAM configuration problems after enabling fingerprint authentication.

Collect relevant logs and configuration details when reporting a problem. Avoid including passwords, authentication tokens, fingerprint images, or biometric templates.

## Uninstallation

The repository provides an uninstallation script:

```bash
less scripts/uninstall.sh
```

Inspect the script before running it. Confirm which files, linker-cache entries, or service changes it removes or restores.

If you decide to uninstall the driver, follow the procedure documented for the version you installed. Do not assume the script restores every previous system setting unless its implementation explicitly does so.

## Tested hardware and software

See [`docs/TESTED-HARDWARE.md`](docs/TESTED-HARDWARE.md) for the project's hardware and software compatibility record.

When reporting a successful test, record the exact:

- Computer model and fingerprint reader USB ID.
- Linux distribution and release.
- Kernel version.
- CPU architecture.
- `libfprint` version or Git commit.
- Driver build and installation method.
- Enrollment and verification results.
- Login and `sudo` authentication results, if separately tested.

Only report results that have actually been tested. Do not mark a distribution, kernel, or computer model as supported solely because it appears likely to be compatible.

## Upstream status

This repository is a community-maintained driver project.

Do not describe the driver as officially supported by upstream `libfprint` unless the relevant implementation has been accepted upstream. If the driver incorporates or adapts code from another project, preserve the original notices, attribution, and applicable license terms.

Contributions, reproducible test results, and carefully documented compatibility reports can help improve the project.

## License and attribution

The repository declares **LGPL-2.1**. Consult the included [`LICENSE`](LICENSE) file for the precise license terms.

Before distributing the driver or prebuilt library, verify that the repository's license and notices are appropriate for every included file. If a binary is built from a modified LGPL-covered library, comply with the applicable requirements for distributing the binary, corresponding source, and notices.

Preserve third-party attribution and licensing requirements for any code adapted from other projects.

## Contributing

When reporting a bug or submitting a contribution, include:

- The USB ID reported by `lsusb`.
- Your distribution and kernel versions.
- The exact `libfprint` version or commit.
- Relevant `fprintd` logs.
- The steps required to reproduce the issue.
- Whether enrollment, verification, login, and `sudo` were tested separately.

Please avoid sharing sensitive biometric data or other private authentication information in public reports.

---

**Project:** [goodix-27c6-5301-fingerprint](https://github.com/shivan-kulal-git/goodix-27c6-5301-fingerprint)

**Maintainer:** [shivan-kulal-git](https://github.com/shivan-kulal-git)

