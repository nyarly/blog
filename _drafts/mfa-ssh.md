---
layout: post
title: MFA SSH
---

An MFA, say Okta
proxy command in SSH config

ssh <server>
triggers proxy command
creates TLS cert,
sends CSR to server
server issues MFA challenge
(Okta/Duo app challenge, or link to auth in slack or...)
server signs cert for short duration
ssh uses cert as credentials.
Target server trusts central creds server,
so authorizes connection.

Open questions:
* control long-lived connections
* re-sign certs for a given period without auth, or with reduced auth
* trust domains - sign certs with different roots.

Research items
proxy_command interface
SSH and certs
