---
layout: post
title: dockerfiledeps
---

Somewhere along the line,
I'm not sure exactly where,
a significant part of my work life
became building Docker images.
Specifically,
writing Makefiles
to build Docker images.

The frustrating thing about this
is that Docker is extremely conservative
about what layers it will cache,
and it rebuilds all the layers after
a layer that changes.
And the reason
that I am writing Makefiles
is that I'm building closely related images,
so they tend to have many layers
in common with each other,
but unique to the project.
The other reason I'm writing Makefiles
is to try to not rebuild things that
don't need to be rebuilt.

As it happens,
I've elsewhere written Go code
against the Docker packages that parse Dockerfile.
It turns out this is relatively simple,
so it was easy to build a utility
that could parse a Dockerfile
and produce a Makefile inclusion
to handle the image's dependencies
on the files it adds
and the image it descends from.

`dockerfiledeps`
is that tool
(written in Go).
Here's how it works:

First,
install `dockerfiledeps`
with the usual Go incantation:
`go get github.com/nyarly/dockerfiledeps`.
Then,
run `dockerfiledeps -emit-driver > driver.mk`
and start a `Makefile`
like
```
REGISTRY_HOST := my.registry.net
REPOSITORY_NAME := project
include driver.mk

push-all: push-foo
  @echo done
```

You create your project repo
with directories for each target image,
where the directory name is the repo name of images.

When image `foo` descends from image `bar`,
start it with `FROM my.registry.net/project/bar:local`.

Then you can `make push-all` and
get the Make goodness of minimal build times.
You can add rules for files in the various image directories
to speed builds, as well.
After all, `dockerfiledeps` is intended
to help and streamline Makefile writing,
not to completely replace it.

If you `ADD .` you won't get much benefit,
but if you're specific about
the files you copy into the image,
your build cycles will see the benefit.
Additionally,
dockerfiledeps uses proxy targets to record
the freshness of built images,
so you get the niceness of not rebuilding images that haven't really changed.

Please do let me know
if you get use out of dockerfiledeps,
or if you run across some deficiency.
Ultimately, because of how Make and Docker interact,
I'm almost sure there are situations
without an ideal solution.
They should all be fixable with Make rules,
though.
