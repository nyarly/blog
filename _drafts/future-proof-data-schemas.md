---
layout: post
title: Future Proof Data Schemas
---

Challenge of any distributed application:
data format has to be decided upon
but if it changes in the future,
clients will be broken

Schemas
Much made of NoSQL and schemaless data.
But why do you hate your (future) self so much?
Also, we embed the idea of single client servers.
So:
define schemas for data.
Distributre schemas.
Best: use a standard definition for the schema.
e.g. SQL data definitions.
Even better: codegen from standard defs
protobufs, cap'n proto
(others, but whatever)
xxx JSON xxx

Fields have data types
Data types change
Most common change: single value to list
Ergo: all values should be lists
Second most common (generalization of previous)
broadening type.
Ergo: use broadest unrelated types
or commit to narrow types.
e.g. always use `text` not `varchar(32)`
or always use timestamp-with-zone
and use midnight UTC for times "don't care"

The pitch for RDF
open world -> all values are lists
(clients have to handle up front)
