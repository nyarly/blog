---
layout: post
title: Layered Error Handling
---

Consider: An SPA to an API over a database.
Also: policy enforcement on a Github repo
(i.e. Github App lints commits, precommit hook)

Goal: Best UX. Most correct.

Each layer must handle errors
A series of loops
Must not represent an error incorrectly
(i.e. no err message when an error would not occur)
Prefer to pass the error back and let the authority handle.

Authority for the error where it is processed.
e.g. DB produces duplicate record errors.
Must not trust front end to handle validation.
We accept that validation will happen multiple times.

Implementation concerns.
Repetition.
Coupling between systems.
And error and validation language?

Errors must be presented sensibly to humans.
Users of the website cannot use "index constraint violated"
Conversely: very useful in logs.

Security errors a special case:
Squashed to single "not allowed" error for strange users.
Sanitized but represented clearly for operators.

[needs diagrams]
