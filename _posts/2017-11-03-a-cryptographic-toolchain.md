---
layout: post
title: A cryptographic toolchain
---

Strong authentication is often a requirement for working with software.
It can be a hassle to manage the secrets required to
adequately protect the integrity of our code
and control access to its deployment.
Many developers give up,
treating the whole game as not worth the candle.

I've cobbled together a solution
involving a Yubikey secure element
that I like a lot,
both for its security,
and its convenience.
The whole process takes about 30 minutes.

# A Cryptographic Toolchain

What we're going to do is set up a [Yubikey](https://www.yubico.com/product/yubikey-4-series/)
not only as a universal two-factor (U2F) token,
but also as a PGP smart-card.
The result will be a strong security element
that you can use to
sign into Github, Gmail and Dropbox,
sign and encrypt files
(including code commits and archives)
and authenticate to SSH servers (include Github for pushes.)
An added value is that the Yubikey can fit in your wallet,
which means you can carry your security keys
on your person,
much like physical keys.

## Setting up the Yubikey

Install ykman (e.g. `brew install ykman`)
- it's a python package, so it's maybe possible to get through `pip`.

Plug in your Yubikey.

First thing to do:
```shell
ykman info
Device name: YubiKey 4
Serial number: 6646987
Firmware version: 4.3.7
Enabled connection(s): OTP+U2F+CCID

Device capabilities:
    OTP:        Enabled
    U2F:        Enabled
    CCID:       Enabled
    OPGP:       Enabled
    PIV:        Enabled
    OATH:       Enabled
```

The really important thing here is the firmware version.
Yubikeys with a firmware below 4.3.5
will need to be [replaced](https://www.yubico.com/keycheck/verify_otp)(it's free!)

We'd like to use the key for all of its functionality.
So let's make sure everything is turned on.
```shell
> ykman mode otp+u2f+ccid
Mode is already OTP+U2F+CCID, nothing to do...
# (you might be asked to confirm the change, and enter the admin password)
```

Next, we'd like to require the key to
wait for us to touch it before signing anything.
This prevents e.g. malware on our laptop from
using a plugged in key to sign bad things as if it were us.
```shell
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

Touch for encryption is probably unnecessary,
but it can't hurt.
`ykman openpgp touch enc on`

## U2F

This is too easy *not* to do.

Go to sites that use U2F
(Google, Github)
and in your account settings,
look for Two-factor authentication devices.
Plug in the Yubikey,
choose "add authentication device"
and when prompted,
touch the blinking light.

## Smart Card Setup

Now we're going to set up a PGP keypair in the Yubikey.
We'll use this to sign code,
but also to authenticate our pushes to Github,
and even sign in to SSH servers.

Start with:
```shell
gpg2 --card-edit
```

This'll put you into an interactive mode with GPG -
note the different prompt.

```shell
gpg/card> admin
gpg/card> passwd
```

Enter `3` to change the admin password.
You'll be challenged with the *default* admin password,
which is `12345678`.
(At this phase, it won't make it clear that it's the default password,
although other GPG commands will remind you.)
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
a 6-digit numeric code applies.

Now, we want to generate a keypair on the key.
In my opinion,
this is one of the best features of this approach.
You generate a keypair in such a way that the private key
(the secret part)
never even leaves the smart-card -
which is designed to never let that data off of the device.
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
      0123456789012345678901234567890123456789
uid                   [ultimate] Judson Lester (General purpose key) <me@judsonlester.info>
sub   rsa4096/0x456789ABCDEF0123 2017-10-25 [A]
sub   rsa4096/0x789ABCDEF0123456 2017-10-25 [E]
```

Note that there are three keypairs above:
a master, signing key (the one marked `[SC]`),
an authentication key (marked `[A]`),
and an encryption key - `[E]`.
There's good reasons for this, but we mostly just need to know which is which.
Further on I'll refer to some key ids like `$AUTHKEY_ID`
which in the above is `0x456789ABCDEF0123`.

Now we're going to publish this key so that other people can use it.
```shell
> gpg2 --send-keys
```

Next, we'll pull the public information back onto the Yubikey from the keyservers.
```shell
> gpg2 --card-edit
gpg/card> fetch
gpg/card> quit
```

## SSH pubkey

Even though GPG and SSH use the same kinds of basic cryptography,
SSH needs a different format for its public keys.
GPG has a handy tool to convert its public keys so that
SSH can use them:
```shell
gpg2 --export-ssh-key $AUTHKEY_ID > ~/.ssh/yubi-ssh.pub
```
Next, we're going to set up gpg-agent so that it can act as an SSH agent.
It's run on its own and provide your Yubikey keypair to
SSH for authentication
and to GPG for signing.

Note: you have to spell our your home directory in the below -
replace $HOME with whatever `echo $HOME` outputs.
`~/.gnupg/gpg-agent.conf`:
```
enable-ssh-support
write-env-file /home/$USERNAME/.gpg-agent-info
default-cache-ttl 28800
max-cache-ttl 86400
default-cache-ttl-ssh 28800
max-cache-ttl-ssh 86400
```

To make this work, you'll need to add this to your `~/.bash_profile`:
```
export GPG_TTY=$(tty)

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
```
That way SSH and GPG will know where to find the GPG agent.
Once you've done that, to get the configs picked up in
any shell that was already running
(like the current one):
```shell
> source ~/.bash_profile
> gpgconf --kill gpg-agent
> gpg-connect-agent \bye
```

### Other keys in agent

You very likely have other SSH keys you'd like to use.
You can use `ssh-add` to put other keys into the gpg-agent.
You'll be challenged for their passphrase once on the command line
and then **again** for a new passphrase for their use in gpg-agent.
Honestly, I tend to use the same passphrase for simplicity.

From then on, if SSH needs that key,
gpg-agent will use its pinentry to ask for
the "GPG" passphrase
(i.e. the new one you enter as you ssh-add).

From now on, when SSH needs that key,
GPG agent will challenge you for its passphrase,
and then make it available to SSH for a set period.

## Git signing

Next, we want to configure Git to use our GPG keypair.

Add this to `~/.config/git/config` (or `~/.gitconfig`)
```
[user]
  signingkey = {last 6 hex of signing key id (e.g. ABCDEF)}

[commit]
  gpgSign = true
[tag]
  forceSignAnnotated = true
```

Now when you commit,
or do annotated tags like:
```shell
git tag -m "Annotated, therefore signed" a-tag
```
git will use your signing key on the item.

## Github settings

Copy `~/.ssh/yubi-ssh.pub` to the SSH pubkeys.
This will let you use your Yubikey to authenticate pushes.

If you need to specify a key in your `~/.ssh/config`,
use `~/.ssh/yubi-ssh.pub`.
This confused me,
since you usually identify keypairs to SSH
by the private key file,
but that "file" is intentionally unavailable.

Copy the output of `gpg2 --export --armor ${SIGNING_ID}` to GPG keys.
This will get you the good feeling of "verified" badges next to your commits.

## Notification

Everything up until now has been simple configuration of stock tools.
The one irritation I had was that,
while I wanted the Yubikey to require interaction before signing anything
(because otherwise any process on the computer could get access to the keys),
the quietly blinking "Y" wasn't quite enough
to get my attention all the time.
What happens is that I'd make a `git commit` and
look away, task complete,
only to have the signature part time out and fail.

So,
I built a little notification engine for the Yubikey.

For now, basically, see
https://github.com/nyarly/socket-notify

You'll need Cargo
(i.e. the Rust dev environment)
set up on your machine to make it work,
but that's easier than you might expect.

First, run
```shell
cargo install socket-notify
```

Then, put this into `~/.gnupg/scdaemon.conf`:
```
log-file socket:///tmp/scdaemon.sock
debug 1027
debug-assuan-log-cats 511
```

Then run
```shell
gpg-connect-agent scd killscd
```
That should restart the program that interacts with the Yubikey as a smartcard.

Make sure socket-notify runs when your computer is running
(I use systemd user services for this, but it depends on your OS.)

The upshot is that when a program challenges the Yubikey for a signature,
you'll get a desktop notification to remind you that you need to touch the button.

## Revocation certificate

If you lose your yubikey,
you want to publish the fact that you can't use that key anymore.
You want to prove that you,
the owner of the key,
are the one publishing that the key isn't any good.
So obviously you want to sign a message to that effect.
But you won't have the key to sign it with anymore.
The way out of this paradox is to generate (and protect)
"revocation certificates,"
essentially pre-signed claims that the key is bad,
ready to distribute when the worst happens.

Current versions of `gpg2` will automatically generate a revocation certificate.
If you don't see a message about "revocation certificate stored as ...",
(or even if you aren't sure)
you can always
```
gpg2 --gen-revoke 0x0123456789ABCDEF > ~/.gnupg/openpgp-revocs.d/yubikey-ABCDEF.gpg.asc
```

You can also generate multiple certificates -
one for each computer you use your Yubikey on, for instance.

You'll want to protect that file carefully -
some suggest backing it up to removable media.
It can't be used to impersonate you,
but if it's published to a keyserver,
other users of GPG will have a hard time trusting the key again.
Which is the point.

### Actually revoking the key

If you lose your Yubikey,
(or, say, it turns out to be theoretically vulnerable to ROCA...)
you revoke the key like this:
```
gpg2 --import ~/.gnupg/openpgp-revocs.d/yubikey-ABCDEF.gpg.asc
gpg2 --send-keys
```

which adds the certificate to your local keyring,
and then publishes it to the keyservers.

Then, start over with this guide.
