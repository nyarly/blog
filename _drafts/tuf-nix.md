---
layout: post
title: TUF Nix
---

The Update Framework is a general purpose registry integrity system.

Nix is a software registry,
and it could benefit from such a system.

TUF is just a framework, though,
a specification.
It would be interesting to build a Nix-TUF.
An enhancement might be
to add a merkle-tree open ledger,
so that the contents of the integrity registry
could be verified later.

Points of research:
review the actual details of TUF.
Define the unit of integrity (an expression file, probably...)
(but, like, drawing in what?)
