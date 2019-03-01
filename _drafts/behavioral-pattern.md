---
layout: post
title: Behavioral Pattern
---

Notes for later:
Net::LDAP by default creates a new network connection per method call.
With a 3 node AD cluster, that's a problem.
You add on one node, and then go to operate on the new entity
but it hasn't replicated yet.

So:
wrap the LDAP object and control its access.
So that you effectively set up transactional behavior:
a series of operations all via the same connection.

Testing that:
we have "full operations" represented as classes.
Good unit tests isolate those and ensure that they work
but not the key property:
that all the LDAP operations happen on a single network connection.

Some of this is because the LDAP functions are "impure"
which makes local reasoning difficult.

There's small integration tests that would address the single-connect behavior.
Types are also a partial address.

Chiefly:
this is an interesting use case
for examining & discussing
software design techniques.
