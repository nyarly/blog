---
layout: post
title: inlinefiles
---

Say you've got a simple web-service to write.
It's going to be a microservice,
and in order to
play nice in its environment,
you want it to serve a static file
with JSON that describes
where it's monitoring page is
and who to get in touch with if it misbehaves.
You could
include a literal JSON string,
but it becomes harder to work with
than it would be in its own file.

When the data is
in its own file,
your editor can highlight the syntax correctly.
It's easier to check that the picky JSON syntax is correct.
JSON files are easier to use in different contexts
than Go string literals that are JSON,
or constant structs marshalled onto the wire.

In Node or Ruby,
you can include the file itself
in the application package,
and refer to it relative to the
endpoint code.
In Ruby, it looks like
```ruby
puts File.read(File.join(__FILE__, '../metadata.json'))
```
## Compiled Languages Though

Coming to Go
from a dynamic languages background,
I got tripped up a bit by the fact that
your source code isn't available
at runtime.
It's obvious in retrospect,
but I was fully prepared to
use `os.Open` and `io.Write`
to emit my JSON to the wire.
But after it's compiled,
Go code doesn't have direct access to its source code.

So somehow we need to
incorporate the data files
into our source code.
We can translate them into strings,
and perform escaping so that regardless of what's in the files,
they're legal string literals.

Go has `go:generate`,
which is very handy for this.
If we include a magic comment in our code,
then running `go generate` on the command line
will run commands to produce code.
There's support in the stdlib
for generating `Stringer` interfaces,
for instance.

It would also be handy
if we could continue to treat the files
_as files_ instead of strings.
In part,
because this means that it's easier to work
with template inclusion.
Also because it means that if we later want
to override the hard-coded files,
we're still using an `os.File` or `io.Buffer`
instead of mixing those types with `string`.

Go has the `vfs` package.
It's part of `go doc`
but it serves our purposes perfectly.
You can define a `mapfs`
which is a literal `map[string]string`,
but allows you to `Open(path)` and get file structs.

So there's a lot of facility to do what we want in go already.
All that's missing is a tool to take
a real directory structure,
and generate the code for a literal map.

## But Where's the Shill?

Here's [inlinefiles](https://github.com/nyarly/inlinefiles) to weld all this together.
`inlinefiles` takes two arguments:
a path to a directory of source files,
and a path to an output file,
and generates Go code to build an equivalent `mapfs`.
There's a few flags to handle things like
using a specific package name (instead of guessing)
and to restrict the files included based on a glob pattern.
It's suitable for using as a `//go:generate` comment
(since that was the motivating case.)

In addition, `inlinefiles` includes a package for
smoothing out using `vfs.FileSystem`s with
Go templates.
It seemed reasonable to add
because the problem is more significant
if you want to use templates.

There's more pressure to use
separate files for templates,
where the concerns about whitespace
for the template output
and for the code itself
are in tension.
Groups of templates are also coupled to one another
when one template includes another.
They need a file hierarchy provided to them,
in the form of paths to the other template files,
or links of some kind of the loaded templates themselves.
It gets a little more annoying to manage.

So, while template handling is in tension with
"do one thing"
but it's a common enough use case,
and the extra code is light enough.

Candidly,
I only started working on `inlinefiles`
after searching for alternatives
and reviewing a few existing packages.
(It's my understanding that `packr` is well thought of,
for instance.)
The thing that drove me to build my own
really was the desire for something small
and easy to understand.
The design intention was
to adhere to the Unix principle
of small tools doing one thing well.
Re-using as much of the Go core tooling
as I could
was an important goal.

## Rewrite It in Rust!

You might've been asking yourself
"if compiled languages have this problem,
why isn't there a Rust analogue of `inlinefiles`?"
Which is a fair question,
but the answer is breathtakingly simple:
the Rust stdlib ships with a `include_bytes!` macro
(and a couple of related ones)
that do exactly this: include the contents of a file
as a `&static [u8]`,
which means that it all happens at compile time,
without needing an additional
(if quite excellent)
build tool.
