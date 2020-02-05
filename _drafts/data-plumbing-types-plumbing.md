---
layout: post
title: Data Plumbing, Types Plumbing
tags: [engineering, practice, types]
---

Dynamically typed languages,
especially
you often need to debug programs
by tracking how data flows through the running program.
This is why println debugging is so facile.
And where inline debuggers shine:
because you can pause execution
**and inspect the current values of variables.**

Arguably, this is part of why
single assignment is so powerful
sometimes aka "immutibility"
because you inescapably capture
each step of transforming data.

As I'm learning more about
type inference
(waves hand in a vague, grand way)
my first reaction has been
dismay because the tools I know best
(`p screwy_value`)
don't help me.
The compiler complains that these types
don't line up
(and, often, rustc complains that it
expects A, but got B
when it looks to me that we've got B
and were surprised by A...)
I can't even get to execution
to see how the data flows.

But with type inference,
the types also flow,
and they likewise need to be
inspected in place.
In Rust,
`let x: () =`
`collect::<[()]>`
are the equivalents to
`println` in Java, say.
I wish I could
get the type infered for
the expression my cursor is over,
honestly - that'd be the equivalent
of inline debugging.

And I'm heartened by this realization:
to the degree that I can trade
type inference
for
data transformation
as the chief operating theory of my programs,
I can ensure that I've caught bugs
**before release.**
And that's huge.

Something about:
regression tests
as automated and encoded
println debugging
including where we create new
joints in the system under test
in order to better capture that behavior
(a good thing!)
and how type inference
especially in Rust's style,
where functions serve as
boundaries where we assert types
"lifts" that technique
into a language feature.
