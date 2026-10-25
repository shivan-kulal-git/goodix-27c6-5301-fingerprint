# Quick Start After a Fresh Install or Reset

These instructions are for the Goodix USB fingerprint reader `27c6:5301`. Read the main [README](README.md) for compatibility and safety notes.

## 1. Check the device

```bash
lsusb -d 27c6:5301
```

Continue only if the expected device is listed.

## 2. Clone the repository

```bash
git clone https://github.com/shivan-kulal-git/goodix-27c6-5301-fingerprint.git goodix_fingerprint
cd goodix_fingerprint
```

## 3. Review and install

The installer requires administrator privileges and may modify system library/service state. Inspect it first:

```bash
less scripts/install.sh
```

If the changes are appropriate for your system, run:

```bash
sudo ./scripts/install.sh
```

## 4. Enroll a fingerprint

```bash
fprintd-enroll "$USER"
```

Follow the on-screen prompts.

## 5. Verify fingerprint recognition

```bash
fprintd-verify "$USER"
```

Successful verification confirms fingerprint matching works; it does not automatically enable login or `sudo` authentication.

## 6. Configure login authentication if desired

Use your distribution's supported settings or PAM configuration. On Ubuntu, inspect available profiles with:

```bash
sudo pam-auth-update
```

Keep password authentication enabled as a fallback and test login and `sudo` separately.

## Notes

- The USB device must report `27c6:5301`.
- The prebuilt library is intended for a compatible x86_64 Linux environment.
- Compatibility depends on the `libfprint` version and build configuration as well as the kernel.
- Review installation and uninstall scripts before running them with `sudo`.
- Do not upload fingerprint images or templates to public issues.
