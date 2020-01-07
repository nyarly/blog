---
layout: post
title: The Machiavellian Approach to Library Packaging
---

This is a response to
https://research.swtch.com/vgo-principles.

Go & Versioning, part **11**

`go get -u C`
breaks because C was tested with D 1.4,
but latest is 1.16
(1.16 introduced a bug)

Discovered one of the ecosystem requirements for a language:
package management.

(TODO: post re: You must include these features
in your lanuage, because they can't be built later
(error handling, modules, packaging))

Why not do what other languages do?
Why not reuse(! a/o/t adopt/bless) Dep?

This is why I wanted to write this:
> [those tools] make software engineering more complex and challenging ...
> make software engineering simpler and easier instead.

This is the kind of reasoning throughout:
> ...Go import paths are URLs.
> If code imported "uuid", you’d have to ask which uuid package.
> Searching for uuid on pkg.go.dev
> turns up dozens of packages with that name

We used DNS as our package registry,
and our subsequent package registry cannot make
DNS names unique based on a substring.
But, it's simpler to fold DNS and git into package naming.

> Go import paths are written in Go source files,
> not in a separate build configuration file.
> This makes Go source files self-contained,
> which makes it easier to
> understand, modify, and copy them.
