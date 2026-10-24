# Dependencies

On a fresh Ubuntu install, you need:
```bash
sudo apt install fprintd libfprint-2-2
```

The pre-built library replaces the system libfprint at runtime via `/usr/local/` (ldconfig will prefer it if configured as we do). All other deps are usually already installed.
