---
layout: post
title: inlinefiles
---

Coming to Go
from a dynamic languages background,
I stumbled over the fact that
your source code isn't available
at runtime.
It sounds obvious and banal,
but like a lot of
software engineering concepts,
they're obvious both before and after the fact.
It's in the moment that they're surprising.

Let me unpack that a little.
Say you've got a simple web-service to write.
It's going to be a microservice,
and in order to
play nice in its environment,
you want it to serve a static file
with JSON that describes
where it's monitoring page is
and who to get in touch with you.
You could well use \` to
include a literal JSON blob,
but it becomes harder to work with
than it would be in its own file.

In Node or Ruby,
you might simply include the file
in the application package,
and refer to it relative to the
endpoint code.
But since Go is compiled,
at runtime, the JSON source
isn't available to the code.

The problem is more significant
if you want to use complicated templates,
where the concerns of whitespace
for the template output
and for the code itself
are in tension.

Go has the `vfs` package.
Go has `go:generate`.
Here's `inlinefiles` to weld all this together.
