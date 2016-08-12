---
layout: post
title: Semantic Versioning, in Reverse
---

This needs a huge edit.
Outlining:

## A Quick Recap
* Intro to semantic versioning
    * Nuts and bolts
## Motivation
    * General value
        * in terms of conservative updates
        * As compared to locked versions
        * as maintainer, adoption
        * as maintainer, warm fuzzies
        * maintainer == consumer

## In Practice
* How do we do that?
    * Consider the changes we've made since last release...
    * In terms of interface
        * What's an interface, exactly

### An Aside about `private`
        * The access keyword story
        * That's an interface


## When Last We Saw Our Heroes
    * What changed: bump like that.
    * Maybe not ready for 1.0 (if we can't apply process)

## Leader and Follower
* In reverse
    * That is: consider changes up front
    * Try to limit changes to interface
       * Make patchlevel changes freely
       * Consider minor version changes carefully
          * Why?
       * Resist major version changes strenuously
          * The ember deprecation method



[Semantic versioning](http://semver.org)
(sometimes called "semver")
is a relatively important concept in modern software development.
It's a formulation of rough understandings of what the various parts of a version number mean
in terms that are well agreed on.

In semver,
a software version
(in general this is loosely true, but in semver it is strictly so)
has three parts:
The major version number,
the minor version number,
and a subversion number (sometimes called the patchlevel.)
The three parts are connected with periods, like this:
**1.3.5**

Semver specifies that those three parts have very distinct meanings.
The major version changes when there are breaking changes to the interface.
The minor version changes when new features are added to the software.
The subversion changes for any other release of the software.

# So Far, So Good

This simple formulation
(and to be clear, this is a simplified version of a straighforward specification)
has raised a lot of ire over time,
not the least of which becasue of how it was implemented by NPM.

One objection that comes up is that
the version of a piece of software is part of its brand.
A 1.0 release implies that the project is in some way
mature or complete.
If we put a 0.9 version on the release
others might pass us over.
By the same token, increasing the minor version
from 1.2 to 1.3 seems to suggest
more work or progress
that a patchlevel bump.

There's the objection that "that's not actually how we version software."
In other words,
that sounds like a good idea,
but really we've always changed versions when it "felt" right.

More challenging is that on certain projects
if we changed the version according to semver,
we'd be advancing the major version with every release.

These certainly aren't all the reservations
that I've heard to using semver,
but they're frequent
and significant.

_Ed: This isn't entirely vanity,
but the reverse perspective is that
the consumers of our software
are right to expect that we accurately signal
its state of development._

# To the Point

So how do we figure out
what version our release should be?

We assign versions during releases.
Releasing is a part of the software development process
(some might say the most important part.)

We've just crushed out some code,
banged out a PR,
and merged it to master.
All the tests pass,
so let's get it out to
NPM or Rubygems or Pip or whatever.
But to do that, we have to decide
what the new version will be.

First of all, the best part about semver it that
until the 1.0 release,
all bets are off.
We're free to make releases and use them in our own code,
or let others try it out and make suggestions,
without yet committing to anything about the interface.
That's a huge and important freedom,
and one to make great use of.

We shouldn't expect
a lot of adoption yet, though.
0.x releases are
purely for early adopters.
Anyone who tells you different
is selling you something.

Because
rapidly changing interfaces are a drag.
As method names change,
and their parameters are updated,
or types and classes get refined,
client code often needs to be
recompiled or even rewritten to make use of the new version.
(There's the option to pin to a particular version,
but then we leave ourselves outside of necessary updates
to correct bugs or security issues.)
Even as the consumers
of our own component,
we want to be able to get to 1.0
so that we can stop thinking about
_this_ component's interface
at the same time as we're working on
_that_ application's feature set.

The way to address the problem of the moving interface target
is to decide on what the interface should be.
At some point we decide
"This!
This is how this should work,
and how it should be used!"
That decision point gets codified in documentation.
_That's_ when we release the 1.0:
as a way of announcing the stablization of the interface.

[XXX How do we decide that? When is 1.0? How soon is now? ]

From then on,
whenever we make a new release,
we need to consider what kind of change we've made:
breaking changes update the major version,
new features update the minor version,
bug fixes update the patchlevel.
Easy!

We still find ourselves,
however,
sometimes thinking
"oh, this release really is a change to the interface...
that should be a major version bump."
And frequent major bumps
are just as annoying
(and time consuming)
as a lot of activity on a 0.x release series.

So now what?

# Interface Design

That's the issue I really want to address, though.
I come to think that some of the furor against semver is because
we've all failed to understand and disseminate
the art of design and maintenance of a software interface.

As a for instance, see if your experience gibes with mine:
when I was first learning object oriented programming, (in Java)
I was really confused by the access keywords.
I think everyone plays with trivia about
what the difference is between `public` and `protected` is,
(like, in Java,
`protected` is defined in relationship to _packages_,
but `private` is in relationship to classes,
or something like that.)
What the access keywords _mean_
is one question.
(With different answers in different languages.)
(Ruby:
`protected` means "defined by a superclass"
`private` means "only with an implicit receiver".)

But the really pointed question is: what are they _for?_
I habored this understanding that
they were somehow defensive -
that `private` methods were somehow "more secure"
than `public` ones.
In retrospect,
the idea is laughable,
but I'm pretty sure I wasn't alone.

Later, relying on Rubydoc to browse code,
I was frequently frustrated by other people using `private`,
since it implicitly hid the code from documentation.
Given the state of documentation in general,
having quick-to-follow links and disclosure of source code was an enormous boon.
So I did two things: I started using YARD
(because it can be configured to ignore access keywords for the purpose of documentation)
and I stopped adding access keywords to my own code.
Everything was `public`, and I liked it that way.

What became clear, though, is that
I was implicitly exposing every method in my libraries as their interface.
When I tried to update libraries I'd released
I'd receive a bunch of issue reports that the new version didn't work
with existing client code.
At one point I considered never changing any of the methods in code I'd released,
but the maintenance nightmare there was too daunting.
The point was,
this is _exactly_ what marking methods `private` is all about:
those are the methods we're saying are off limits
to outside consumers of our code,
and it's off limits so that we're free to change it.hjj
Seeing how access keywords were being used poorly,
I'd abandoned a useful and powerful tool.

The truth is that access keywords are
a kind of enforced documentation.
They let us establish for other developers
(first, and most of all)
what parts of our library are its interface,
and what's retained as internal implementation.
Best of all, the rules about use are enforced
at the language level, so
there cannot be any confusion about what's what:
if the compiler allows it, it's in the public interface.

The simple rule about marking code entities
(that is: functions, methods, classes, constants, whatever)
public is one way you're saying to the consumers of your code
"this is the interface - this is how to use it."
When I was marking everything public,
I was mixing in the useful interfaces with
little utitlity functions.
If you're using my library,
you're within your rights to make use of anything marked public.
And if I remove those methods or change their signatures,
you're right to be (loudly) annoyed;
the responsible thing, in fact, is to cease to use the library.

# From Access to Interface

Moving quickly on from issues of open-source entitlement and programmer motivation,
imagine the converse case:
all my methods are public,
and the audience for my excitingly popular library use all of them
what do I do when I want to change one of those methods?

I might want
to provide a new feature,
or reduce repetition,
or improve the structure of the code.
There's tons of reasons to make changes to a library,
but if all my methods are public and therefore consumed
(even just theoreticially)
by some client code
the I can't get any of the value of making those changes
without breaking someone else's program.

[ XXX There's more motivation to interfaces than code agility ]

The interface also serves as
a point of entry,
an introduction to a component for newcomers.
An idiomatic interface communicates
the purpose
and abilities of a module.

Since interfaces serve as the seams
between pieces of an application,
they also serve as natural points of intrumentation.
The interfaces are where interaction happens,
and we can meaningfully inspect that interaction
to get a view on what the application is doing.

Likewise,
interfaces are excellent subjects of testing,
both as boundaries of a tested unit,
and also as the template for dummies
to replace the component when testing.

So what do we do about defining our interface?
The actual process is pretty open,
and I've had good experiences with many different approaches.
Sometimes, I know well enough what the code needs to do
that I can define the interface up front,
write tests first
and let the tests drive the development.
Other times, libraries arise from an existing application,
and the trick is to figure out
where the boundary between the specific application
and the reusable library lies.
Regardless, the problem to solve is where that boundary is
and what the points of access are through the boundary.

Incidentally, automated tests are great for this.
Even if you don't do test driven _development_,
using tests to drive the _design_
will lead to nicer interfaces,
and the tests will help control regressions between versions of your library.
Plus, well written tests can go a long way towards documenting the interface,
although it must be said,
they don't replace the need for good prose documentation.

# Planning Ahead

From there,
you quickly get a sense of what kind of update you're contemplating.
Some changes need to be put off,
because they'd involve making breaking changes,
and you don't want to do a major version bump.

One particularly elegant technique
involves the idea of "deprecating" interfaces.
As interfaces become older,
or you add features that supplant them,
tag them
(with a comment, or using documentation markup)
as being deprecated.
When you decide that either
the new interfaces are robust enough or
that the old interfaces aren't carrying their weight enough,
remove all the deprecated interfaces at once and do a major version release.
(The EmberJS project espouses this technique,
and it's a practice I've always admired.)

Now you've stumbled into responsible maintenance of a library.
The authors of client applications will thank you.
