---
layout: post
title: JSON and langsec
---

I believe but cannot prove
that JSON (as typically used)
is Turing complete to actually parse.

JSON
(as defined as ECMA-404 and IETF-XXX)
does not restrict object keys to be unique.
Every consumer (practically) treats objects as an associative array,
which means they assume keys are unique,
so JSON parsers have to handle duplicate keys
which typically happens silently.

At the very least, this is an opening for a hash collision,
since I can "hide" a field, and then play with its value.

What I cannot prove is this contention:
```
The language that consists of lists of alphanumeric tokens
without repetition
is Turing complete.
```
