--
layout: post
title: Semantic Versioning, in Reverse
---

# A Quick Recap

[Semantic versioning](http://semver.org)
(sometimes called "semver")
is a relatively important concept in modern software development.
It's a formulation of rough understandings of what the various parts of a version number mean
in terms that are well agreed on.

A software version (in general this is loosely true, but strictly so in semver) has three parts:
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

There's the objection that "that's not actually how we version software" -
in other words,
that sounds like a good idea, but really we've always changed versions when it felt right.
More challenging is that on certain projects if we changed the version according to semver,
we'd be advancing the major version with every release.

# Interface Design

That's the issue I really want to address, though.
I come to think that some of the furor against semver is the result of
a collective failure to understand and disseminate
the art of design and maintenance of a software interface.

As a for instance, see if your experience gibes with mine:
when I was first learning object oriented programming, (in Java)
I was really confused by the access keywords.
I think everyone plays with trivia about
what the difference is between `public` and `protected` is,
but the really pointed question is: what are they _for?_

Later, relying on Rubydoc to browse code, I was frequently frustrated by other people using `private`,
since it implicitly hid the code from documentation.
Given the state of documentation in general,
having quick to follow links and disclosure of source code was an enormous boon.
So I did two things: I started using YARD
(because it can be configured to ignore access keywords for the purpose of documentation)
and I stopped adding access keywords to my own code.
Everything was public, and I liked it that way.

What I came to understand, though, is that
I was implicitly exposing every method in my libraries as their interface.
Seeing how access keywords were being used poorly,
I'd abandoned a useful and powerful tool.

The simple rule about marking code entities
(that is: functions, methods, classes, constants, whatever)
public is that you're saying to the consumers of your code
"this is the interface - this is how to use it."
If you mark everything public, you're mixing in the useful interfaces with chaff.
If I'm using your library, I'm within my rights to make use of anything you make public.
And if you remove those methods or change their signatures,
I'm right to be (loudly) annoyed;
the responsible thing, in fact, is to cease to use your library.

Moving quickly on from issues of open-source entitlement and programmer motivation,
imagine the converse case: if all my methods are public,
and the audience for my excitingly popular library use all of them
what do I do when I want to change one of those methods
to provide a new feature,
or reduce repetition,
or improve the structure of the code.
There's tons of reasons to make changes to a library,
but if all my methods are public and therefore consumed by some client code
the I can't get any of the value of making those changes without breaking someone else's program.

Thinking along these lines,





Semver lays out what various version changes imply about the the code that is
versioned.

It's often easier to update the version based on the the changes that were made
since last release.


It requires more discipline, but still better is to resist or postpone making
changes to code that will require "more significant" version changes.
