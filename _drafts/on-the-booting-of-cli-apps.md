---
layout: post
title: On the booting of CLI apps
---

This isn't likely to be mindblowing,
but it seemed to me to be
the collective wisdom of many years of
software engineering,
but I couldn't find it spelled out anywhere.




First problem is the loading of configuration.
File, env, command line.
Command line should take precidence,
on the principle that it changes most immediately.
The user's intention is most immediately reflected
by command line switches,
because they were provided when we launched.
Next most immediate are environment variables,
since they can be changed very easily.
Config files are the slowest to change,
so should (generally) have the lowest priority.

Generally,
it makes sense
for there to be several config files
at least a system config
and a per user config.
For applications where there's such a thing,
a per-workspace config also makes sense.
Because of their generality,
the files should override each other in that order: 
workspace over user over global.

A challenge here is that
the sources of config files should be
changeable from the command line.
