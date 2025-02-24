---
layout: post
title: 'Design Doc: Secret Management'
---

Motivation: IBM buys Hashicorp
(after long setup, where cause and effect are confusing)
Also: I'm told OpenBAO is no good.

# Sketch

Encryped RAFT datastore.
Regular language over TLS.
Capabilities: biscuits, where request is a "fully constrained" biscuit.
Modules, separate executables, secure comms to server, with config/data stored in datastore

# Flows

authenticate -> time limited biscuit for `(user,X),(action,mint)`
mint a new "root" capability
constrain to `(verb,subject)` or `(verb,subject,object)`
issue request with constrained biscuit
response with success/error with regular message
success responses generally will be (encoded) values, or empty
error messages: client error vs server error, with free-form extra information

# Verbs

* mount
* mint
* set
* get
* commit/perform

## Mount

Estabilish an instance of a service module;
pair a unique service name with a provider binary

## Mint

Get back a capability biscuit related to future operations.
Might be either capabilites related to an existing resource,
or the start of a new resource.

possible: client_error related to attempt
to create/access a resource without authorization

## Set

Contrained on a minted biscuit, to set values
Count be a direct k/v to be stored securely,
or configuration for a service
or constucting a more complex operation

## Get

Constrained on a minted biscuit,
to get values, either from a k/v
or as the results of secure operations

# Use Cases / Ops Concerns

Secure setup, including K8s-ready
Init produces unlock tokens, sets up admin account
Backup/restore vs. rollback
IaC for services and authorization vs. actual secrets
TLS CA
Rolling credentials
Separate Web app for human access (vs. 1password)
Human use of machine credentials
 (e.g. Samantha's concern about database access)
