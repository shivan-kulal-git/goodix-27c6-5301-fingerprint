# Quick Start After a Fresh Install or Reset

Follow these steps to install and configure the Goodix `27c6:5301` fingerprint sensor driver on a supported Linux system.

## 1. Clone the Repository

```bash
git clone https://github.com/shivan-kulal-git/goodix-27c6-5301-fingerprint.git goodix_fingerprint
cd goodix_fingerprint
```

## 2. Install the Driver

Run the installation script with administrator privileges:

```bash
sudo ./scripts/install.sh
```

Follow any prompts displayed by the installer. Review the installation script before running it with `sudo`.

## 3. Enroll Your Fingerprint

After installation, enroll a fingerprint for your current user:

```bash
fprintd-enroll "$USER"
```

Follow the on-screen instructions to complete enrollment.

## 4. Verify Fingerprint Authentication

Test the enrolled fingerprint:

```bash
fprintd-verify "$USER"
```

Confirm that the verification succeeds before configuring fingerprint authentication for login or other system services.

## 5. Enable Fingerprint Login

If fingerprint verification works, open **Settings → System → Users** and enable fingerprint authentication if the option is available.

For Ubuntu systems, you may also configure fingerprint authentication through PAM using:

```bash
sudo pam-auth-update
```

Select the fingerprint authentication option if it is available. Keep password authentication enabled as a fallback.

## Requirements and Notes

- The sensor must report USB vendor/product ID `27c6:5301`.
- Root or `sudo` privileges are required for installation.
- The system must have the dependencies required by the installer.
- The driver is intended to integrate with the system's `libfprint` and `fprintd` stack.
- Support depends on the Linux distribution, library versions, and hardware configuration.
- System updates may affect a custom driver installation.
- Review the installation and uninstallation scripts before modifying system libraries.

**Repository:** https://github.com/shivan-kulal-git/goodix-27c6-5301-fingerprint
