---
layout: post
title: Where to put code
---

In a microservices context

introduce a common service
(creds managment, discovery, event stream audit tables...)
or a common pattern
(retry/backoff)

Where does the code for that belong?

No silver bullet,
but I see a lot of weak grasp on this problem.

It could go
in the service - or a new service
in clear documentation of the pattern/protocol
a schema language (ideally with codegen)
in libraries
in a sidecar

Good example of off-the-shelf wins, where they exist.

Consider carefully the cost to develop solutions.
Last-mile for existing products often a better use of time.
