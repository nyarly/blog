---
layout: post
title: Layered Error Handling
---

Consider: An SPA to an API over a database.

Best UI. Most correct.

Each layer must handle errors
A series of loops
Must not represent an error incorrectly
(i.e. no err message when an error would not occur)

Authority for the error where it is processed.
e.g. DB produces duplicate record errors.

Errors must be presented sensibly to humans.
Users of the website cannot use "index constraint violated"
Conversely: very useful in logs.

Security errors a special case:
Squashed to single "not allowed" error for strange users.
Sanitized but represented clearly for operators.

[needs diagrams]
