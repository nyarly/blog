---
layout: post
title: Web Authorization Thoughts
---
I've been mulling an idea for web authentications, that I'd like to discuss a
little bit in public before developing it in more detail.

Here's the problem I'm trying to address: developing user interfaces for
authorization-controlled applications is a pain in the neck. You wind up having
to lace "if_authorized?(something)" around links and forms, and make sure that
the conditions you're applying align with what the affordances will actually
do. Even looking past the labor that requires, it means that there's another
set of variation in your pages, and that describing that variation to a cache
in between may be difficult. (You could add something like an
Authorized-By-Role header and tag it in the Vary ... but does every cache
respect that header properly?)

In a world rushing towards the Single Page Application, I've started to think
along these lines:

Let's consider ReSTful actions as the objects of authorization. That is: if you
can PUT to /user/1, you can PUT anything to /user/1 - we're not going to
consider individual parameters. We're also going to control for a specific set
of HTTP actions, and anything not considered should be rejected by the server.

For every pair of {action, uri}, let's list a set of tokens that are authorized
to perform that action. These tokens are arbitrary and opaque - they have no
characteristics beyond identity - if I tell you "xyzzy" once, and "xyzzy"
another time, I mean the same thing, but that's all. I don't mean you can
teleport or something.

Every authenticated user also has a list of tokens - effectively permissions
that they are granted. When a user attempts an action, we can compare the list
of tokens they possess to the list of tokens that grant the action. If there's
an intersection, the action proceeds. If there's not, well, here's your 401
page.

Now, all these tokens exist and are managed on the server. A user can inspect
the tokens they have access to (maybe /user/:id/tokens, or as the body of the
401...) and the affordances for any action can have its tokens associated with
it (e.g. data-access-token="xyzzy,fnord,tacos"). But clients never transmit to
the server the assertion that they have a token, and the server certainly
doesn't respect such an assertion. We look up your tokens based on your
authentication every time you make a request that requires authorization.

Now your SPA JavaScript can do the comparisons and come to a conclusion about
whether you'll actually be allowed to perform an action, and if not do
something with the UI. For instance, it could completely remove a form, grey
out a link, or whatever.

On the back end, there'd need to be a means to manage the tokens effectively. I
have a vague conception of a rules processor that can turn "user X has access
to /user/X, and user admin has access to all user/:x" into rules tokens.
There's also the ever-present issue of un-authenticated users, but I think
that's a special case - all authenticated users have the same (very limited,
possibly empty) set of tokens.

I recognize that this scheme exposes some more URIs than eliding affordances
completely. I think that's a security-through-obscurity concern though: it
reveals the existence of locked doors, since the <strong>reason</strong>
they're revealed it because we've locked them down.

I'm dimly aware that this resembles other authorization approaches - it's
possible that there's nothing novel here at all. If so, fantastic! I'd love to
know that there's a well known best practice and redirect efforts along those
lines.

I'm concerned that I'm overlooking something in terms of the security of the
approach though, which is why I'm talking about it in public.

Any thoughts? Resources I should review?
