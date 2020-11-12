---
layout: post
title: Request Handling in Gotham
---

Some confusion about handlers, pipelines, middleware, etc.

Here's the journey of a request through Gotham.

A gotham server starts with `gotham::start`
puts a `NewHandler` in a `GothamService`
feeds it network requests.
The `GothamService` implements `hyper::service::Service`
Puts details of the HTTP request
into a `State`,
calls `new_handler` on the root `NewHandler`
and calls `handle(state).await` to
bind the fresh `State` to the new `Handler`
and resolve the resulting `Future`.
This is also where panics are caught
and turned into 5xx responses.

A lot of the time,
the root `NewHandler`
is a `Router`.
Like a lot of `NewHandler` implementations,
`Router` simply `clone()`s itself
to create a `Handler`.
It's the `handle()` method
that gets interesting.

`build_router` receives
a `PipelineHandleChain`,
a `PipelineSet`
and the closure that does the actual building.
The builder itself
has convenience wrappers
(`get`, `post`, etc)
around `request` -
which is what you'd expect in an HTTP framework.
Those methods all return a `SingleRouteBuilder`
primed to match the method and path given.
The `SingleRouteBuilder` receives one of its
`to_*` methods
which all devolve to `to_new_handler`,
which wraps a `DispatcherImpl` in a `RouteImpl`
and records that in the route `Tree`.
The `RouteImpl` is responsible for matching requests
and dispatching them to the `DispatcherImpl`.

A `PipelineHandleChain` is a construction
that makes it possible to build a nested set
of middleware `FnOnce(State)`s
and call them all
on a repeated basis.
Practically,
the Chain is a car/cdr list
built out of `(Handle, Chain)` tuples.
The end of the list is a `()` -
when the `PipelineHandleChain` is called,
each "segment" builds a closure that
invokes a `MiddlewareChain`.
Which is itself a list constructed on tuple-pairs,
where the nodes are `Middleware`s.

Explaining Piplelines and Middleware needs an honest to god diagram.

MiddlewareChain on (Middleware, MiddlewareChain):
fn call(self, state, f) { (m,p) = self; p.call(state, m.call(state, f)) }
so result is that (m, (t, (u, ()))) -> m.call(s, || t.call(s, || u.call(s, f))), where f is like a handler.
Upshot being that each middleware's m.call
can do what it wants,
invoke the Chain it receives with a state,
(possibly changed)
then manipulate the resulting `HandlerFuture`
and return that.
There are examples of a no-op,
adding data to the `State`,
conditioning the rest of the chain,
decorating the response,
and of an async middleware.
XXX Are there implementations for these?
