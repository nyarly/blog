---
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
I come to think that some of the furor against semver is


Semver lays out what various version changes imply about the the code that is
versioned.

It's often easier to update the version based on the the changes that were made
since last release.


It requires more discipline, but still better is to resist or postpone making
changes to code that will require "more significant" version changes.
