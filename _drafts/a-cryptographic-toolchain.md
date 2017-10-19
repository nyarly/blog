---
layout: post
title: A cryptographic toolchain
---

# A Cryptographic Toolchain

(there are many like it, but this one is mine.)

Yubikey, gpg-agent, some secret sauce.

## Setting up the Yubikey

Install ykpersonalize.

```
sudo ykpersonalize -m86:30 # without sudo it complains about usb device permissions.
```

`-m86:30` will set up all the bells and whistles.
We mostly care about CCID mode for now,
but U2F is really handy as well.

## Revocation certificate

```
gpg2 --gen-revoke 0x1817B08954BF0B7D > ~/.gnupg/openpgp-revocs.d/yubikey-1817b0.gpg.asc
```

### Actually revoking the key

```
gpg2 --import ~/.gnupg/openpgp-revocs.d/yubikey-1817b0.gpg.asc
gpg2 --send-keys
```
