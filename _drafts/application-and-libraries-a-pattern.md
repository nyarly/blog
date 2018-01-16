---
layout: post
title: Application and Libraries, a Pattern
---

# Notes

An application should have enough information in it to update/reinstall.
(Go exes that broke after Sierra update)

Application is right scope.
System is too broad.
Library too small.
Sytem too broad: multiple applications forced to
abitrarily choose between library versions.
(glibc & kernel?)
Library too small because of
opaque data structure.
Application is the scope within which
we consider memory layout and
function interfaces.

By implication,
the system needs to be able to
install multiple versions of a library
provide the correct version to an application


Native extensions in Ruby?

# Draft

In the past decade or so,
we've seen a huge uptick in reusable software.
From Linux distributions built around packinging systems,
up through the unrelenting firehose that is NPM
we're seeing more (and more useful) reusable libraries.

This is a fantastic win in so many ways.
It really is possible to go from a rough idea
to a working prototype now
just by collecting a bunch of libraries
and writing a little glue code.

I don't know that there's been a lot of rigorous investigation,
however into how all these libraries are
should be arranged into running software.
Absolutely, every programming environment
that admits the idea of resuable components
has to address how they're
all linked up into software
but I see these designs repeating a lot of commonalities,
often without understanding how existing systems have solved the same problems.

Which is understandable:
packaging and reuse are big problems,
and it's hard to evaluate a particular design in this space
in scopes of less than months if not years.

As a result,
and this is certainly an opinion,
but it's founded in experience and observation,
while various solutions are better and worse
and some are very bad,
there are very few very good packaging systems out there.

# Terms

Before we get too far into this,
I want to define some terminology.
Several of these words have meanings
(often vague or ambiguous)
in the general discussion of software development,
so I want to make it clear what I mean by them.

An application defines scope of execution.
In other words,
roughly speaking,
when a process starts on a computer,
the code that will be executed
in that process is circumscribed by an application.

Library is a unit of code reuse.

Applications should make use of libraries.

This is not always so.
Some applications are single atomic chunk of code,
and sometimes that's okay.
When, for instance, your code fits into a single screen of text.

In the ideal case,
an application consists merely of
a list of library dependencies
and thin glue of how they interact.
Authors embarking on writing new applications
should consider how
their novel code
might be provided as a library
and actually distribute an application that depends on the library code.

Conversely, if it isn't novel,
use a library,
adapt to its implementation
submit PRs back to the authors.

Libraries themselves have dependencies.

When we resolve the dependencies of an application,
that means that
first we collect a list of all the libraries that the application depends on.
Then we look at the dependencies of those libraries
and collect them into the list.
We keep doing this until we don't add any more libraries to the list.
Finally, we determine which version(s) of each library we'll be use.
The resulting complete list
of libraries and their versions
is the resolved dependencies of the application.

# A Pattern

What I want to propose is a design pattern around the packaging of systems.

There are some components to this pattern.
First,
the client application -
the software that motivates the use of the software packages
a set of libraries included in the application,
the dependencies between libraries and the client application
and
an execution environment which circumscribes the dependency resolution.
Within a particular execution environment, the dependencies are resolved once -
that is, each dependent package should have a version determined for it.

The absolute key to this pattern is the identification of the execution context.
The rather circular definition being:
the execution context is
the scope at which
**XXX**

Execution contexts cannot blend.
They can be composed using interfaces,
so long as those interfaces are
of a different kind of the library composition interfaces.

Here's why:
imagine that I've got two versions
of the same library available to a particular component.
Call them version 1 and version 2.
I might call a function from version 1 and get an X value back.
I might reasonably assume that
I can pass that X to functions in version 2 that receive Xs.
But the opacity of that value is
part of the guarantees of good encapsulation,
and it's completely reasonable that
the library changed the meaning of X between versions.

The way to guard against that
is to separate the differing versions
with interfaces controlled at the execution environment level.
Two different running applications can
both make use of different versions of the same library
and communicate with one another via e.g. network calls.
Each can translate those calls into wire formats and back,
and we know that each instance of our library
is receiving the same kind of thing each time.

A separate but related problem
is how to provide a repository of libraries.
To be sure this is an important issue,
and better packaging systems solve it as well.
It's pretty clear how the two problems are related:
if you're going to resolve the dependency graph of an application,
you need to have a reference of the available providers of its dependencies.
Once you have that reference, you might as well collect and distribute the
libraries themselves.

# Criteria

Bundler + Rubygems, erlang (release vs. application), Rust's Cargo.

Libraries should provide ranges of known (and optimistic) compatibility.

Library versions should be semantic,
human readable, and sequential.
It should be clear that one version precedes another,
at the bare minimum,
and if a contract is asserted
about how the version relates changes
in the library's interface, that should be documented.
In general, semantic versioning is to be preferred,
but like software licenses,
that relationship and statements about it are up to the maintainers.
(In some ways, this is a harder decision,
since a work can be seperately licensed,
but a version policy is for every consumer.)

An application should _fix_ the exact versions of its libraries.
The process of fixating an application's dependencies
should be as automatic as possible,
but human intervention is often required and should be allowed for.
Once fixed, the dependencies of the application are _flat_
- the dependencies of an application are resolved
- based on the transitive closure of the dependencies of the libraries,
- but once resolved becomes a simple list of pairs like `(library, precise version)`.

The author of the **application** has the ultimate right and responsibility
to determine the versions of libraries their application uses.
Automatic resolution should ease this process, not subvert it.
The **user** of an application,
regardless of their technical savvy,
should never have to determine the versions of libraries their software uses.

In order to accomplish this, an application's desired libraries should be
enumerated, complete with versioning, and a tool used to attempt to resolve the
versions required. Failed resolutions should be reported to the user, but
otherwise the resolved precise versions should be recorded. The execution
context should rely on the precise versions.

## Antipatterns

Multiple versions of a single library within an application is an anti-pattern
(or at least counter-indicated by this pattern).
At the very least,
there's the existant chance that data returned by one version of a library
might be passed back into the interface of a different version.
The clients of the differing libraries would be acting in best possible faith,
and the libraries themselves might have acted in best integrity
with regards to versioning their interfaces.
The resulting bugs are difficult to locate,
hard to resolve,
and are completely the fault of the packaging system.

Resolving library versions at runtime is also suspect.
Versioning policy is an excellent idea.
It's absurd to suggest that every library author
can completely encode the compatiblity characteristics
of their library into its version number.
Small but significant variations can creep in unintentionally,
and it is unreasonable to expect "bug-level" compatibility of an interface over time.

Integration of an application can be reasonably tested by its author.
Once precision versions of libraries have been locked down,
the performance of the application can be tested
(automatically, of course) by its author,
and release held unless its behavior is deemed correct.

Inflicting such integration concerns on end users is at best unfortunate.
Changes, for instance, to glibc or libcairo are especially painful.

Application versioning is its own challenge,
since most applications have their own interface
which may change over time.
While an interface that is only used by humans
can get away with letting users "figure it out"
(a policy which will certainly win friends),
those interfaces are rarer than might appear.
File formats and wire protocols are both interfaces
that must either maintain compatibility,
or else be themselves versioned,
and the versions associated with the underlying application.
Even command line interfaces,
which are usually intended for a human user,
may require consideration in versioning an application,
since they are often executed as part of a script
and their output inspected by other tools.
