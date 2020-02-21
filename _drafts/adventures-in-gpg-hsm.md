---
layout: post
title: Adventures in GPG HSM
tags: [gpg, crypto, technique]
---

# Yubikey CA

This is an exercise based on https://github.com/jymigeon/gpgsm-as-ca

I was somewhat incredulous that the AKI and SKI fields would be SHA-1s of the pubkeys
but RFC5280 (which describes PKIX certs) indicates
that they're non-authoritative identifiers of the pubkeys,
and considered non-critical.
It's not particular,
actually,
as to how they're produced,
so long as they're a consistent "name" for the keypair.
So, it would be acceptable,
if unusual
to use SHA-256 instead
(there's an RFC7093 that suggests such a thing,
but it goes to great pains to point out that it's
merely informational,
and that none of the cryptographic features of a hash function
are a requirement of the KI fields.)

All that said, per 7093, sha256 cut to 160 bytes seems acceptable.
So, just to be contrary
(and mindful of GPG hacks related to using hash colisions on keygrips)
I'm using `openssl sha256 | cut -b-40` to generate my SKIs.
(With it in mind to do likewise in a tool-to-come.)

Had to copy _a_ private key to the associated keygrip in ~/.gnupg/private-keys-v1.d/
to get gpgsm to sign the "CSR"

Thing I learned: CSRs include a signature of certificate-related attributes.
Makes total sense in retrospect

I think Werner is wrong here, kinda:
https://lists.gt.net/gnupg/users/83034

Okay, so this approach doesn't appear to work -
taskserver rejects the cert
because the key doesn't match.
I should figure out a way to test that outcome.

Commands of note:

```
# Exporting the pubkey
gpg2 --export-ssh-key 0x12E21E4B9A3F82AA > root-pub.ssh
# Convering to pkcs8
ssh-keygen -e -m PKCS8 -f root-pub.ssh > root-pub.pem
# Computing sha256 based KI
openssl asn1parse -strparse 19 -noout -in root-pub.pem -out /dev/stdout | openssl sha256 -r /dev/stdin | cut -b-40 > root-ski
# Building the CA root cert
gpgsm --gen-key --batch --output root_cert.der < root-cert.gpgsm
# Convert DER to PEM
openssl x509 -inform DER -out root-cert.pem < root_cert.der
# Creating a self-signed "handling" cert
openssl req -x509 -nodes -newkey rsa:4096 -keyout handling_key.pem -out handling_cert.pem -subj '/O=certificate handling service/' -extensions v3_ca

{receive a CSR}
# Signing CSR into a cert for import
openssl x509 -req -in test_req.pem -CA handling_cert.pem -CAkey handling_key.pem -CAcreateserial -out intermediate_cert.pem
# Import into gpgsm
gpgsm --import intermediate_cert.pem
# Find keygrip of cert
gpgsm -k --with-keygrip --with-colons | grep -e 'grp\|uid'
# Finding the offset to the pubkey information:
openssl asn1parse -i -in intermediate_cert.pem
# SKI for entity
openssl asn1parse -strparse 195 -noout -in intermediate_cert.pem -out /dev/stdout | openssl sha256 -r /dev/stdin | cut -b-40 > entity-ski
# Subject from req
openssl req -in test_req.pem -subject -noout | sed 's/^subject=//;s/ //g' > entity-subject
{edit end_entity.gpgsm}
# Building the CA root cert
gpgsm --gen-key --batch --output test_cert.der < end_entity.gpgsm
# Convert DER to PEM
openssl x509 -inform DER -out root-cert.pem < root_cert.der
# OOPS
openssl x509 -modulus --noout -in test_cert.pem | openssl sha256
openssl rsa -modulus -noout -in test_key.pem | openssl sha256
# this also returns an error
openssl pkcs12 -export -in test_cert.pem -inkey test_key.pem -out test.pkcs12
# self-signed cert and key
openssl req -x509 -nodes -newkey rsa:4096 -keyout test_key.pem -out test_cert.pem -subj '/CN=test'
```
