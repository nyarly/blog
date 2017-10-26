---
layout: post
title: A cryptographic toolchain
---

# A Cryptographic Toolchain

(there are many like it, but this one is mine.)

Yubikey, gpg-agent, some secret sauce.

[ TODO Overall goal ]

## Setting up the Yubikey

Install ykpersonalize.

```
sudo ykpersonalize -m86:30 # without sudo it complains about usb device permissions.
```

`-m86:30` will set up all the bells and whistles.
We mostly care about CCID mode for now,
but U2F is really handy as well.

Install ykman (yubikey-manager)

```
> ykman mode otp+u2f+ccid`
Mode is already OTP+U2F+CCID, nothing to do...
# (you might be asked to confirm the change, and enter the admin password)
> ykman openpgp touch aut on
Current touch policy of AUTHENTICATE key is OFF.
Set touch policy of AUTHENTICATE key to ON? [y/N]: y
Enter admin PIN:
Touch policy successfully set.

> ykman openpgp touch sig on
Current touch policy of SIGN key is OFF.
Set touch policy of SIGN key to ON? [y/N]: y
Enter admin PIN:
Touch policy successfully set.
```

Touch for encryption is probably unnecessary.
`ykman openpgp touch enc on`


## U2F

This is too easy not to do.

Go to sites that use U2F
(Google, Github)
and in your account settings,
look for Two-factor authentication devices.
Plug in the Yubikey,
choose "add authentication device"
and when prompted,
touch the blinking light.

## Smart Card Setup

```
gpg2 --card-edit
```

```
gpg/card> admin
gpg/card> passwd
```

Enter `3` to change the admin password.
You'll be challenged with the *default* admin password,
which is `12345678`.
Then for the new password,
and a confirmation repeat.
It's my understanding that you want to limit yourself
to an 8-digit numeric code -
some environments will allow alphanumerics,
but others won't, and you won't be able to use
the Yubikey there.

Then enter `1` to change the user password.
Like the admin password,
you'll need the *default* password,
which is `123456`.
The same advice about using

```
gpg/card> generate
```

You'll be asked for the keysize of three different keys
(signature, encryption and authentication)
which I set to `4096` out of an abundance of caution.
On modern hardware
there's pretty much no downside.
Note that the NEO can't handle keys that large,
so stick to the still-decent `2048` bit keys.

You may also want to specify
personal details on the card itself -
these don't carry over from the identifiers embedded in the keys.

```
gpg/card> list
...
gpg/card> name
...
```

Finally,
```
gpg/card> quit
```

You can check that gpg has a hold of the key by
```
> gpg2 --list-keys --keyid-format 0xlong
```
The new key should be the last one.

Looks like
```
...
pub   rsa4096/0x0123456789ABCDEF 2017-10-25 [SC]
      9EB2E24B3D545F30732E62A112E21E4B9A3F82AA
uid                   [ultimate] Judson Lester (General purpose key) <me@judsonlester.info>
sub   rsa4096/0x456789ABCDEF0123 2017-10-25 [A]
sub   rsa4096/0x789ABCDEF0123456 2017-10-25 [E]
```


```
> gpg2 --send-keys
```

```
> gpg2 --card-edit
gpg/card> fetch
gpg/card> quit
```

## SSH pubkey

```
gpg2 --export-ssh-key $AUTHKEY_ID > ~/.ssh/yubi-ssh.pub
```

https://keychest.net/roca and plug in that public key.
Vulnerable keys indicate an older Yubikey, which should be replaced.

`~/.gnupg/gpg-agent.conf`:
```
enable-ssh-support
write-env-file /home/USERNAME/.gpg-agent-info
default-cache-ttl 28800
max-cache-ttl 86400
default-cache-ttl-ssh 28800
max-cache-ttl-ssh 86400
```

[TODO: .profile for ssh_agent]

### Other keys in agent

[ Motivation ]


You can use `ssh-add` to put other keys into the gpg-agent.
You'll be challenged for their passphrase once on the command line
and then **again** for a new passphrase for their use in gpg-agent.

From then on, if SSH needs that key,
gpg-agent will use its pinentry to ask for
the "GPG" passphrase
(i.e. the new one you enter as you ssh-add).

## Git signing

```
[user]
  signingkey = {last 6 hex of signing key id}

[commit]
  gpgSign = true
[tag]
  forceSignAnnotated = true
```

`git tag -m "Annotated, therefore signed" a-tag`

## Github settings

Copy `~/.ssh/yubi-ssh.pub` to the SSH pubkeys.

Copy the output of `gpg2 --export --armor ${SIGNING_ID}` to GPG keys.

## Notification

This part is probably the flaky-est.
It's my own setup,
borne of wanting to be reminded to use the key when I need to.

For now, basically, see
https://github.com/nyarly/socket-notify

You'll need Cargo
(i.e. the Rust dev environment)
set up on your machine to make it work,
but that's easier than you might expect.

```
cargo install socket-notify
```

`~/.gnupg/scdaemon.conf`:
```
log-file socket:///tmp/scdaemon.sock
debug 1027
debug-assuan-log-cats 511
```

Make sure socket-notify runs when your computer is running
(I use systemd user services for this, but it depends on your OS.)

## Revocation certificate

Current versions of `gpg2` will automatically generate a revocation certificate.
If you don't see a message about "revocation certificate stored as ...",
(or even if you aren't sure)
you can always
```
gpg2 --gen-revoke 0x0123456789ABCDEF > ~/.gnupg/openpgp-revocs.d/yubikey-ABCDEF.gpg.asc
```

You'll want to protect that file carefully -
some suggest backing it up to removable media.
It can't be used to impersonate you,
but if it's published to a keyserver,
other users of GPG will have a hard time trusting the key again.
Which is the point.

### Actually revoking the key

```
gpg2 --import ~/.gnupg/openpgp-revocs.d/yubikey-ABCDEF.gpg.asc
gpg2 --send-keys
```
