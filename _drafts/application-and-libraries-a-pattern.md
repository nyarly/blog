---
layout: post
title: Application and Libraries, a Pattern
---

Bundler + Rubygems, erlang (release vs. application), Rust's Cargo.

An application defines scope of execution. In other words, roughly speaking,
when a process starts on a computer, the code that will be executed in that
process is circumscribed by an application.

Libraries are reusable code components. In fact, the _unit_ of reusable code
should be considered to be "the library."

Applications should make use of libraries.

This is not always so. Some applications are single atomic chunk of code, and
sometimes that's okay. When, for instance, your code fits into a single screen
of text.

In the ideal case, an application consists merely of a list of library
dependencies and thin configuration of how they interact. Authors embarking on
writing new applications should consider how their novel code might be provided
as a library and actually distribute an application that depends on the library
code.

Libraries themselves have dependencies.

Libraries should provide ranges of known (and optimistic) compatibility.

Library versions should be semantic, human readable, and sequential. It should
be clear that one version precedes another, at the bare minimum, and if a
contract is asserted about how the version relates changes in the library's
interface, that should be documented. In general, semantic versioning is to be
preferred, but like software licenses, that relationship and statements about
it are up to the maintainers. (In some ways, this is a harder decision, since
an work can be seperately licensed, but a version policy is for every
consumer.)

An application should _fix_ the exact versions of its libraries. The process of
fixating an application's dependencies should be as automatic as possible, but
human intervention is often required and should be allowed for. Once fixed, the
dependencies of the application are _flat_ - the dependencies of an application
are resolved based on the transitive closure of the dependencies of the
libraries, but once resolved becomes a simple list of pairs like `(library,
precise version)`.

In order to accomplish this, an application's desired libraries should be
enumerated, complete with versioning, and a tool used to attempt to resolve the
versions required. Failed resolutions should be reported to the user, but
otherwise the resolved precise versions should be recorded. The execution
context should rely on the precise versions.

Multiple versions of a single library within an application is an anti-pattern
(or at least counter-indicated by this pattern). At the very least, there's the
existant chance that data returned by one version of a library might be passed
back into the interface of a different version. The clients of the differing
libraries would be acting in best possible faith, and the libraries themselves
might have acted in best integrity with regards to versioning their interfaces.
The resulting bugs are difficult to locate, hard to resolve, and would be
completely the fault of the packaging system.

Resolving library versions at runtime is also suspect. Versioning policy is an
excellent idea. It's absurd to suggest that every library author can completely
encode the compatiblity characteristics of their library into its version
number. Small but significant variations can creep in unintentionally, and it
is unreasonable to expect "bug-level" compatibility of an interface over time.

Integration of an application can be reasonably tested by its author. Once
precision versions of libraries have been locked down, the performance of the
application can be tested (automatically, of course) by its author, and release
held unless its behavior is deemed correct.

Inflicting such integration concerns on end users is at best unfortunate.
Changes, for instance, to glibc or libcairo are especially painful.

Application versioning is its own challenge, since most applications have their
own interface which may change over time. While an interface that is only used
by humans can get away with letting users "figure it out" (a policy which will
certainly win friends), those interfaces are rarer than might appear. File
formats and wire protocols are both interfaces that must either maintain
compatibility, or else be themselves versioned, and the versions associated
with the underlying application. Even command line interfaces, which are
usually intended for a human user, may require consideration in versioning an
application, since they are often executed as part of a script and their output
inspected by other tools.
