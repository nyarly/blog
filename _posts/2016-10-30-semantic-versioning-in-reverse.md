---
layout: post
title: Semantic Versioning, in Reverse
---

As phenomenal a concept as it is,
semantic versioning
often gets a bad rap.
Many developers
publicly express their frustration
(or even contempt)
for this tidy codification of
a core principle of software design:
the definition of interfaces.
I tend to think that it's not
semantic versioning
that's badly understood,
but the idea of
what an interface is
and how to design one.

## A Quick Recap

[Semantic versioning](http://semver.org)
(sometimes called "semver")
is a relatively important concept in modern software development.
It's a formulation of rough understandings of
what the various parts of a version number mean
in terms that are generally agreed upon.

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

## Motivation
The value of semantic versioning as a practice comes from
the terse, precise communication about
the compatibility of software over time.

Faced with a software problem,
we often imagine, correctly,
that someone has had a similar problem and solved it already.
When we find such a library,
now the problem becomes making good use of that library.

It's extremely valuable to be able to
find code ready-made to provide functionality we require,
especially when it involves the implementation of a standard protocol
or the encapsulation of an API.
Truthfully, there are many reasons that a code library might be
useful,
and why we'd want to make it reusable.

Like everything in engineering,
there are trade-offs.
And one of the trade-offs of reusable software
is maintaining compatibility.
It's frustrating when
a library your software has come to depend on
releases and update,
and how your code won't compile because
it expects features of that library that have changed.
How many hours (or years!) of developer time
have been burnt in the effort
to adapt to a shifting interface?

One longstanding solution to using that code is to
copy it wholesale into your code and
use it as if you'd written it from whole cloth.
Some modern systems persist with this approach,
often describing the procedure as
"checking in vendored code"
or simply "vendoring."
The chief and abiding advantage to this approach
is that you don't have to worry about
the boundary between your code and
the third-party library anymore.
It's all yours, for good or ill.

If there were bugs in the library at the moment we copied it,
now those are our bugs to maintain.
Since we're not the original author,
we don't have the advantage of bug reports from other users.
So, those bugs are likely to be fixed by the upstream maintainer.
More urgently, fixes to security issues
should be propagated as quickly as possible,
but we're sitting on an old copy of the code.

Beyond the very real maintenance issues,
it's easy (but often wrong) to
disregard new features made available in newer versions.
Often those new features are attractive for
the same reason that the library was attractive in the first place:
they'll save us implementation time.

The problem is, how can we know that
updating to a new version of the software
won't break the application that depends on it?
Maybe we'll need to do more work
keeping up with changes in the library we're tracking
than we would to simply do just the maintenance we need ourselves.
Of course, we can't know for certain
whether that's true.
Once you start considering the possibility
you'll always wonder about
what could have been.

So we're caught in a bind:
we can choose to never update
and accept or remediate bugs and security flaws,
or we can adopt code wholesale and become a second maintainer,
or we can cope with the breakages that occur when we update.
All of these choices sounds like terrible propositions.
The virtue of semantic versioning is that we can
reduce the cost of the last option,
by making the breakages more predictable,
or even offering the assurance that a particular version
won't break our application.

So, as a consumer of third-party libraries,
the value of well managed semver is pretty clear.
It's a way out of the update bind.
As a maintainer,
we get the good feeling that we're "taking care" of our users.
More concretely, we can hope and expect that
our software will see greater adoption,
which we might desire for a number of reasons.

Most of all, semantic versioning is about
recognizing that writing software is a human act:
we write software for other humans.
Part of doing things with and for each other
is communicating about what we're doing.
Semantic versioning provide really powerful support for that communication.
It's a well known shorthand
for complicated ideas,
as well as being a social prompt to
talk about the context your software expects.

But also don't ignore the
case where the maintainer of a library is also its primary consumer.
There's amazing value in being able to set down one project
sometimes for months,
and work on another than consumes its interface
without worrying about the details inside it.
Clear communication with yourself
months from now
is at least as valuable as
communication with a larger community of developers.

## In Practice

Every new release of a piece of software
should have a new version number.
The versions should always increase.
In some ways, the version acts as
a kind of counter,
marking out releases on a timeline.

But every new release *could*
increase any of the three components
of the version.
So how do we figure out
what version our release should be?

The first release is easy: start with 0.0.1
and no one can say that you're wrong.
But after that, how do we decide how to
increment a version?
In other words, should we bump
the major,
minor,
or subversion
for this release?

First of all, the best part about semver it that
until the 1.0 release,
all bets are off.
We're free to make releases and use them in our own code,
or let others try it out and make suggestions,
without yet committing to anything about the interface.
That's a huge and important freedom,
and one to make great use of.

By the same token,
0.x releases make no promises.
Anything can change at any time,
which is good in the early days
of a new package.
But when you're trying to *use* the package,
that's really a drag.

At some point we decide
"This!
This is how this should work,
and how it should be used!"
That decision point gets codified in documentation.
_That's_ when we release the 1.0:
as a way of announcing the stabilization of the interface.

The 1.0 release is important.
It's a moment when we say to all our consumers
(who might be ourselves, five minutes in the future)
"Trust me to shepherd this code."
We're making a commitment,
and we should take that seriously.

From then on,
whenever we make a new release,
we need to consider what kind of change we've made:
breaking changes update the major version,
new features update the minor version,
bug fixes update the patchlevel.
Easy!

Of course,
that reasoning presupposes that we understand
what makes for a breaking change.
And to reason about that,
we have to have decided on our package's
_interface._

### An Aside about `private`

That's the issue I really want to address, though.
I come to think that some of the furor against semver is because
we've all failed to understand and disseminate
the art of design and maintenance of a software interface.

As a for instance, see if your experience gibes with mine:
when I was first learning object oriented programming,
(in Java)
I was really confused by the access keywords.
I think everyone plays with trivia about
what the difference is between `public` and `protected` is.
Like, in Java,
`protected` is defined in relationship to _packages_,
but `private` is in relationship to classes,
or something like that.
but in Ruby
`protected` means "defined by a superclass"
`private` means "only with an implicit receiver".
What the access keywords _mean_
is one question.

But the really pointed question is: what are they _for?_
I harbored this understanding that
they were somehow defensive -
that `private` methods were somehow "more secure"
than `public` ones.
In retrospect,
the security idea is laughable,
but I'm pretty sure I'm not alone.
But `private` is safer than `public`
in a very different sense.

Later, relying on Rubydoc to browse code,
I was frequently frustrated by other people using `private`,
since it implicitly hid the code from documentation.

If you're paying careful attention,
you'll notice that
I'm talking about using a _documentation_ tool
to _browse code._
Because of the tragic state of documentation
(and Github README files are not helping...)
that's really what those tools are good for anymore.
Another way to put that is
I went to use Rubydoc to find out what a particular method does,
and how it interprets its parameters,
and the docs were either _not there_ or _not useful._
But there was a "show source" button, and I could puzzle it out from there...
until there are method calls in the source body.
No problem, I can just find the docs for those methods and repeat...
unless those methods are marked `private`.

Given the wretched state of documentation in general,
(and for a prime example, check out [this yokel's profile.](https://rubygems.org/profiles/nyarly "i.e. mine"))
I did two things: I started using [YARD](http://yardoc.org/)
(because it can be configured to ignore access keywords for the purpose of documentation)
and I stopped adding access keywords to my own code.
Everything was `public`, and I liked it that way.

What became clear though, is that
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
and it's off limits so that we're free to change it.
Seeing how access keywords were being used poorly,
I'd foolishly abandoned a useful and powerful tool.

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

Here we find another trade off.
Private aspects of a library are easier to change over time
because only the library itself uses them,
and if its tests all pass, we can be confident we haven't broken anything.
But to be useful, we have to
expose some parts as public.
What to expose means predicting which uses will be
most common
or most powerful
for the consumers of the library.
Exposing everything means we leave that decision up to our users,
but it means that every change will break somebody's program.

The simple rule about marking code entities
(that is: functions, methods, classes, constants, whatever)
public is one way you're saying to the consumers of your code
"this is the interface - this is how to use it."
When I was marking everything as public,
I was mixing in the useful interfaces with
little utility functions.
If you're using my library,
you're within your rights to make use of anything marked `public`.
And if I remove those methods or change their signatures,
you're right to be (loudly) annoyed;
the responsible thing, in fact, is to cease to use my library.
After all, it's causing unplanned maintenance work to keep up with,
and it's likely to keep causing that work.

# From Access to Interface

Moving quickly on from issues of open-source entitlement and programmer motivation,
(which are both important and well covered elsewhere)
imagine the following case:
if all my methods are public,
and the audience for my excitingly popular library use all of them
what do I do when I want to change one of those methods?

I might want
to provide a new feature,
or reduce repetition,
or improve the structure of the code.
There's tons of reasons to make changes to a library,
but if all my methods are public and therefore consumed
(even just theoretically)
by some client code
the I can't get any of the value of making those changes
without breaking someone else's program.

The interface also serves as
a point of entry,
an introduction to a component for newcomers.
An idiomatic interface communicates
the purpose
and abilities of a module.
A small interface
focuses that communication to the things that are important,
where a broad interface risks losing that focus.
There are times where that's acceptable,
but exposing everything as public discards that value
without good purpose.

Since interfaces serve as the seams
between pieces of an application,
they also serve as natural points of instrumentation.
The interfaces are where interaction happens,
and we can meaningfully inspect that interaction
to get a view on what the application is doing.

Likewise,
interfaces are excellent subjects of testing,
both as boundaries of a tested unit,
and also as the template for dummies
to replace the component when testing.

Like any useful communication,
designing interfaces can be hard.
Specifically, deciding where the interface is,
and what's not can be hard.
Why else would well meaning designers cede the question entirely?
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
A lot of the time, though,
I discover an interface only as the software comes into being,
and gets real-world use.
Regardless, the problem to solve is where that boundary is
and what the points of access are through the boundary.

Incidentally, automated tests are great for this.
Even if you don't do test driven _development_,
using tests to drive the _design_
will lead to nicer interfaces,
and the tests will help control regressions between versions of your library.
Plus, well written tests can go a long way towards documenting the interface.
It must be said though,
they don't replace the need for good prose documentation.

## When Last We Saw Our Heroes

But we were talking about how to apply semver to our projects.

With a solid interface, we can set the 1.0 version.
From there, the process of determining the version for a new release is straightforward.
We simply ask ourselves
the questions implied by the semver definition
and go from there.
That is, first we look at
this release
as compared to the last
to find what changed.

Then we ask:
"did we change the interface?
Are there methods or types missing,
or still present but changed in incompatible ways?
Did any methods change their parameters?"
If the answer is yes, then we need to bump the major version.

"Did we add to the interface?
Are there new methods or types?
Did existing methods learn to accept a wider array of values?"
If the answer is yes, we need to bump the minor version.

"Are all the changes in this revision to fix bugs?
Are the changes or additions from the previous two questions
**only** made because we'd released an implementation that
doesn't support the interface we'd intended?"
If we can answer this yes, then we can get away with a subversion bump.

So, the hard part is setting the interface.
Keeping semver is actually pretty easy.
Right?

## Leader and Follower

A careful read will notice there's some tension in those questions.
We're letting some major version bumps be reduced to subversions
in certain circumstances.
How is that okay?

In a perfect world,
it wouldn't be.
We'd never need to release subversion
bumps in the first place.
Heck, we wouldn't need versions in the first place,
because all software would be perfect on the first release.
But the fact is, we make mistakes.
There's a point of view that says that the release
is the ultimate arbiter of the change,
and that just because you didn't intend a particular interface,
that's what you released,
so you're stuck making a major version release.

My personal opinion is that it's more nuanced than that.
Hard lines on how versions get set lead to us supporting
bug-level compatibility in our software forever.
And one of the virtues of making semver releases,
(and of releasing open source software)
is being able to say
"if you needed this bug,
lock to that exact version."

That said,
it's certainly better to avoid
"interface not as intended" subversion releases.
Especially if there's been a lot of adoption of the previous version
(and a lot of package distribution systems will let you count downloads)
or if a lot of time has passed
(which is essentially a proxy for adoption.)

Even more so, we'd like to avoid making major version releases.
If they happen with real frequency,
we're not really providing benefit to anyone by using semver.
The whole point of major versions
is that they signal that we've broken the interface.
If we do that frequently,
then we give up one of the key advantages of semver.

Likewise, we'd like to be careful about our minor version releases.
Each implies an extension of the interface,
which starts to erode the focus of purpose
that our interface should communicate.
It ends up making it harder for newcomers to understand
what our code does and how to use it.
There's a way in which each minor version release implies
we didn't know what the interface should look like,
and so maybe we still don't know what it should look like.
(There's a Halting Problem analogue there,
but it's a variety that's hardly unique in our discipline.)

## At Last, The Point

So here we come, finally,
to the core thesis.
If we're going to try to avoid major and minor version releases,
we need to avoid making changes to our interface,
either breaking changes or additions.
And to avoid those changes, we need to consider the changes we're *planning* to make,
not just the changes we've actually made since the last release.

In other words, rather than figuring out how our version is affected by our changes,
we need to figure out how our planned changes with affect our version.
That's what I mean by "semantic versioning in reverse,"
and it's actually part of the practice of
software engineering,
and part of why it might be reasonably called
a discipline.

## On the How

If you're convinced,
or just curious,
you might be asking
"okay, but how do I get there?"
First of all,
the structure of this essay is advised.
I really think that you learn to do
the "well considered changes" thing
by first making what changes seem called for,
and then categorizing them.
That's part of why semantic versioning is so useful:
if only as an exercise towards considered change,
it's amazingly valuable.

As time goes on,
and on smaller projects,
the change to version
can become a useful shorthand for examining
contemplated changes.
And, indeed, towards discovering where your interfaces lie
and what they should look like.
One larger projects,
the same skills come to bear,
but it may require more formal processes to control well.

As an example of a lightweight process,
check out how [Ember.js](http://emberjs.com/deprecations/) handles this.
They've set up in-library support for deprecating parts of their interface.
If you use a deprecated method, you get a warning,
and that's all.
When a major version lands,
all the deprecated parts of the interface go away.
There's drawbacks to this approach
(people complain about "deprecation spew")
but it means that the upgrade path to the next major version
should be clean and straightforward.
