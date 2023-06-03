---
layout: post
title: Wishlist for Kubernetes' successor
---

Kubernetes is great
It committed to some things early
Maybe won't ever evolve out of those commitments
might not want to

I am not going to build a successor to Kubernetes

A successor would
Nested namespaces

Operators
first class - "stdlib" past Pods implemented as operators
Deployment vs Statefulset

Less need for Operators
either init-system deps
or ship with Estragon
i.e. emulate systemd or (better) s6/runit/daemontool

Scheduling
CPUs vs Memory (whole other post)
Service level(name?) for req=limit
Taints and rescheduling
PDBs, taints, etc etc. - unified

Better schema behaviors
mutable fields as part of schema

Consistent waiting
(Deployment vs Statefulset)

Rendevous _a la_ NixOS modules
i.e. I need
a database,
secrets management
logging
iow e.g. CNI is too specialized;
a general theory of cluster interfaces

Basically: a small set of abstract primitives
MK: a configuration store and reconciliation
Is that all you need?
Not quite, but look askance of features that have concrete subjects.
Build a porcelain layer for Deployment/Statefulset, Node, PVs etc.

Audit resource creation
