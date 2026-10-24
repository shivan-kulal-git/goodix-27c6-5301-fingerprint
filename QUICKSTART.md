# Quick Start After Fresh Install/Reset

1. Clone this repo:
```bash
git clone <your-github-repo-url> goodix_fingerprint
cd goodix_fingerprint
```

2. Install:
```bash
sudo ./scripts/install.sh
```

3. Enroll your fingerprint:
```bash
fprintd-enroll
```

4. Use for login/sudo via Settings or PAM as normal.

Notes:
- Requires root/sudo
- Works with the system's fprintd
- Device must be 27c6:5301
