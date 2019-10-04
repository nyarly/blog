---
layout: post
title: Why Does Go Development Feel Slow?
---

# Why Does Go Developement Feel Slow?

Not sure why, but it does.

## Structure and Semantics

```golang
if err != nil
```

And

```golang
for _, i := range items {
```

There's a point at which
re-writing list operations
and basic error handling
becomes a little tedious.

Go 2 is promising on this front,
with generics and new errors,
but I remain somewhat skeptical.

## Longer Development Cycles

Compile & test & try.

Must test, must experiment,
because language support for preventing errors
is minimal.

Specifically,
a spartan type system,
and nulls,
mean that runtime errors are common.
Also, null method receivers.

## Editor Tooling

Deoplete? Just bogs down Vim?
