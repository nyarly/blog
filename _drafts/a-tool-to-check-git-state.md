---
layout: post
title: A Tool to Check Git State
---

Lots of prompt.sh include
a little function to put a glyph in the prompt
if your current git repo
has new files
has modifications
everything is committed, but there are commits not pushed
there are tracked commits not merged.
And your current branch.

For principled software release,
many of these conditions matter,
plus
is the current commit tagged
(and lightweight vs. signed)
is the current commit signed
has the tracked remote been pulled recently.

You would like to be able,
at some time in the future,
to be able to review the code that's running in production.

Or be able to take you laptop with you
to code on a plane,
or a desert island.

Or ensure that a collaborator
really is talking about the same code
when they say it can't compile.
