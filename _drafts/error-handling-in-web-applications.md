---
layout: post
title: Error Handling Across Layers
tags: [web, software, practice]
---

Errors and input have a deep and subtle relationship.

Errors should be handled as soon as they can be.

They should be handled where they can be dealt with accurately.
e.g. DB should handle uniqueness.

They should be handled early for short loops.
e.g. SPA should filter input for reponsiveness,

They should be handled authoritatively.
e.g. DB should handle consistency.

Errors presented to users should be meaningful and actionable.
e.g. _not_ "E33 Constraint violated"

Options for error handling:

Single component:

Could be close to the user -
* can't trust it (user can manipulate, end-run)
* coupling issues with multiple clients (all have to handle errors the same)
* timing & consistency

Could be centralized -
* Slow responses
* Meaningless errors (DB constraint violations)
* Errors disconnected from input

Could be middle-tier -
* Weak compromise of both

Multiple Components
* Allow for faster handling of errors when they can be handled at a client level
* Closer to the user, we know more about the context and can present more useful messages
* We can get the benefits of centralized error handling, in terms of strong consistency.
* We can model validity more completely in the middleware.
* Cross data-component validity, for instance. Business rules.

But!
* Our error handling overlaps, and we have a whole new class of problems.

Makes sense to guard deeper layers from input that would for sure be invalid.
e.g. - an age requirement that we can model in SQL or JavaScript.
But, we must ensure that we avoid rejecting good input -
If the SQL says `AGE >= 18`, the JS shouldn't say `user.age > 18`

We might want to reproduce e.g. a uniqueness constraint
as a feral consistency thing
so that _usually_ you can say "User name taken"
but the DB can simply reject a transaction.

## Something Else

XXX Needs a diagram
Some of this is based on the difference between two perspectives:
A central server for expanding rings of increasingly user-friendly clients.
vs
A "stack" of front-end, middleware, back-end, database. (or whatever)

From the "central server" perspectives,
the stack is a wedge cut out of the concentric circles.
From the "stack" perspective,
the centralization is irrelevant - maybe even YAGNI.

Error handling / Input validation happens as we cross rings.
Might not happen _in_ either ring -
Consider a Kubernetes Operator exposing an admission webhook.

Important pattern:
Most validation rejects invalid input,
but sometimes we want to accept something invalid provisionally,
and perform "hard" validation when we commit to _using_ the input.
Consider a mortgage application,
or a workflow configuration.
We want to allow a user to save their work and come back,
but only submit/activate the input if it's _then_ completely valid.
