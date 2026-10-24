# Testing

1. Reset permissions and check device:
```bash
fprintd-list $USER
```

2. Enroll fingerprint:
```bash
fprintd-enroll
```

3. Verify:
```bash
fprintd-verify
```

4. Test with PAM (for sudo/login):
```bash
pamtester login $USER authenticate
```
