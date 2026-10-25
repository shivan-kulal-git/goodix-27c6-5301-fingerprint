# Troubleshooting

This guide provides initial diagnostics for the Goodix `27c6:5301` fingerprint driver. Inspect command output before sharing it publicly.

## Device is not detected

```bash
lsusb -d 27c6:5301
lsusb -t
```

If the first command returns no device, check the USB connection and confirm the actual vendor/product ID. A different ID may require a different driver.

## `fprintd` reports “No devices available”

```bash
systemctl status fprintd --no-pager
journalctl -u fprintd -b --no-pager
lsusb -d 27c6:5301
```

Check that the driver library is installed in the intended location and is compatible with the system's installed `libfprint`. A matching USB ID alone does not prove that the driver has loaded.

## Enrollment or verification fails

```bash
fprintd-enroll "$USER"
fprintd-verify "$USER"
journalctl -u fprintd -b --no-pager
```

Record the exact error message and relevant logs. Do not share fingerprint images, templates, or other biometric data.

## Missing library or loader errors

```bash
ldconfig -p | grep -i fprint
```

Check the installer's documented destination and confirm that the installed library matches your architecture and `libfprint` environment. Do not copy random libraries from another distribution or version.

## Service errors

```bash
systemctl status fprintd --no-pager
journalctl -u fprintd -b --no-pager
```

Restarting the service may be useful after installation:

```bash
sudo systemctl restart fprintd
```

## Fingerprint works in `fprintd` but not at login or with `sudo`

Successful `fprintd-verify` does not automatically configure PAM. Check your distribution's supported authentication settings. On Ubuntu:

```bash
sudo pam-auth-update
```

Keep password authentication enabled as a fallback. Before changing PAM, ensure you have another way to access the machine in case authentication configuration breaks.

## Information to include in a bug report

- Laptop model and distribution version.
- Kernel version (`uname -r`).
- USB ID (`lsusb -d 27c6:5301`).
- `libfprint` and `fprintd` versions.
- Whether enrollment and verification work.
- Relevant `fprintd` logs.

Never attach fingerprint images or templates.
