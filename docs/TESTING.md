# Testing

## 1. Confirm the device is present

```bash
lsusb -d 27c6:5301
```

If it is not listed, confirm the USB ID and connection before continuing.

## 2. Check enrolled fingerprints

```bash
fprintd-list "$USER"
```

## 3. Enroll a fingerprint

```bash
fprintd-enroll "$USER"
```

Follow the prompts and record whether enrollment succeeds.

## 4. Verify the fingerprint

```bash
fprintd-verify "$USER"
```

Successful verification confirms fingerprint matching, but does not prove login or `sudo` authentication is configured.

## 5. Optional PAM test

Keep password authentication enabled and ensure you have another way to access the system before testing PAM.

Install `pamtester` if needed:

```bash
sudo apt install pamtester
```

For example, test the `login` PAM service:

```bash
pamtester login "$USER" authenticate
```

This is meaningful only if fingerprint authentication is configured for that PAM service. `login` and `sudo` use different PAM service configurations; test each separately if you intend to support both.

Do not change PAM configuration blindly or disable password fallback.

## 6. Record results

Update `TESTED-HARDWARE.md` with the laptop model, USB ID, OS, kernel, architecture, exact `libfprint` release/commit, and separate results for enrollment, verification, login, and `sudo`.

If a test fails, follow `TROUBLESHOOTING.md`. Never share fingerprint images or templates.
