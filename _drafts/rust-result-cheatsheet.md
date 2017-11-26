---
layout: post
title: Rust Result Cheatsheet
---

So:
(Not actual syntax, but IMO clearer)

```rust
A Result<T,E> has got:

map<T,U>(fn(T) -> U) -> Result<U,E>
map_error<E,F>(fn(E) -> F) -> Result<T,F>

and_then<U,E>(fn(T) -> Result<U,E>) -> Result<U,E>
or_else<E,F>(fn(E) -> Result<T,F> -> Result<T,F>
```

Maps can be simpler, but can't result a full result.

A `Future` (from `futures::future`) has:
```rust
map<T,U>(fn(T) -> U) -> Result<U,E>
map_error<E,F>(fn(E) -> F) -> Result<T,F>

and_then<U,E>(fn(T) -> Result<U,E>) -> Result<U,E>
or_else<E,F>(fn(E) -> Result<T,F> -> Result<T,F>

//and also...
then<F,B>(fn(Result<Item, Error>) -> IntoFuture
```

There's strong parallels there, but Future is a **trait**,
so its type parameterization is different.
