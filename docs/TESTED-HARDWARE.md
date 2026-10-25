# Tested Hardware and Software

Record configurations actually tested with this driver. Do not mark a configuration as tested based only on its USB ID. Replace placeholders with verified values before publishing results.

## Author-tested configuration

| Item | Value |
|---|---|
| Laptop model | Dell Vostro 3491 — confirm exact test machine |
| USB ID | `27c6:5301` |
| Distribution and release | Ubuntu 24.04.x — record exact release |
| Kernel | Record output of `uname -r` |
| Architecture | Record output of `dpkg --print-architecture` |
| `libfprint` release/commit used to build driver | Record exact version or commit |
| Driver build method | Prebuilt library / source build — specify |
| Fingerprint enrollment | Pass / Fail / Not tested |
| `fprintd` verification | Pass / Fail / Not tested |
| Desktop login authentication | Pass / Fail / Not tested |
| `sudo` authentication | Pass / Fail / Not tested |
| Suspend/resume after enrollment | Pass / Fail / Not tested |

## Other hardware

Add entries only for additional models actually tested.

| Laptop model | USB ID | OS / kernel | Result |
|---|---|---|---|
| Add only after testing | `27c6:5301` | Record exact versions | Not tested |

## Collect version information

```bash
lsb_release -a
uname -r
dpkg --print-architecture
dpkg-query -W libfprint-2-2 fprintd 2>/dev/null
```

For a custom source build, also record the upstream Git commit and Meson configuration. The installed distribution package version may not identify the source tree used for a separate prebuilt library.
