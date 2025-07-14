---
layout: post
title: Vault Successor Design
---

Musings about an open-source Vault alternative

KMS autoseal, keysharing for encrypted data: Good!
Encrypted recovery/unseal keys: Good!
Add: Automatic delivery of encrypted keys

More opinionated.

Capabilities for access.

WASM for in-enclave automation e.g. rotating keys

Cubbyhole?

K8s/cloud native considerations
- operator? init/unseal. Unneeded?
- nodes join cluster, unseal & deliver encrypted keys
- new nodes simply join

Proxy, Agent, K8s Secrets?

Encryption/Secret OS
Secure "Kernel" vs. Access "Userspace"

Kernel
authn - userspace challenge -> token
authz - caps tokens
crypto primitives
resource access - (caps) network connections, ...?
secrets - caps(k, <->, v) (datalog)

userspace registration - endpoints (cap controlled), caps for userspace

Userspace
authn challenges
secret transformations
protocols (SSH, TLS)
