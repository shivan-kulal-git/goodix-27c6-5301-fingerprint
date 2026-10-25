# Troubleshooting

Inspect command output before sharing it publicly.

## Device is not detected

```bash
lsusb -d 27c6:5301
lsusb -t
```

If the device is not listed, check the USB connection and confirm the actual vendor/product ID.

## `fprintd` reports “No devices available”

```bash
systemctl status fprintd --no-pager
journalctl -u fprintd -b --no-pager
lsusb -d 27c6:5301
```

Check that the driver library is installed in the intended location and is compatible with the installed `libfprint`. A matching USB ID alone does not prove the driver loaded.

## Enrollment or verification fails

```bash
fprintd-enroll "$USER"
fprintd-verify "$USER"
journalctl -u fprintd -b --no-pager
```

Record the exact error and relevant logs. Never share fingerprint images, templates, or other biometric data.

## Missing library or loader errors

```bash
ldconfig -p | grep -i fprint
dpkg --print-architecture
```

Check the installer's documented destination and ensure the library matches your architecture and `libfprint` environment. Do not copy random libraries from another distribution or version.

## Service errors

```bash
systemctl status fprintd --no-pager
journalctl -u fprintd -b --no-pager
```

After installation, restarting the service may help:

```bash
sudo systemctl restart fprintd
```

## Fingerprint works in `fprintd` but not at login or with `sudo`

Successful `fprintd-verify` does not automatically configure PAM. On Ubuntu, inspect supported authentication profiles with:

```bash
sudo pam-auth-update
```

Keep password authentication enabled as a fallback. Ensure another recovery route is available before changing PAM. Login and `sudo` use separate PAM service configurations and should be tested separately.

## Information for a bug report

- Laptop model and distribution version.
- Kernel version (`uname -r`).
- USB ID (`lsusb -d 27c6:5301`).
- `libfprint` and `fprintd` versions.
- Whether enrollment and verification work.
- Relevant `fprintd` logs.

Never attach fingerprint images or templates.
