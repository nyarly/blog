---
layout: post
title: dockerfiledeps
---

Somewhere along the line
(I'm not sure exactly where)
a significant part of my work life
became building Docker images.
Often,
clusters of related Docker images.
Specifically,
writing Makefiles
to build Docker images.

A frustrating thing about this
is that Docker is extremely conservative
about what layers it will cache,
and it rebuilds all the layers that follow
a layer that changes.
When the reason
that I am writing Makefiles
is that I'm building closely related images,
they tend to have many layers
in common with each other,
but unique to the project.
Another reason I'm writing Makefiles
is to try to not rebuild things that
don't need to be rebuilt.

I like to
maintain a tight development cycle
for all my projects,
and the length of Docker builds
was getting to me.

As it happens,
I've elsewhere written Go code
against the Docker packages
that parse the Dockerfile format.
It turns out this is relatively simple,
so it was easy to build a utility
that could parse a Dockerfile
and produce a Makefile inclusion
to handle the image's dependencies
on the files it adds
and the image it descends from.
Effectively,
we want `gcc -M`
but for `docker build`.

`dockerfiledeps`
is that tool.
Here's how it works:

First,
install `dockerfiledeps`
with the usual Go incantation:
`go get github.com/nyarly/dockerfiledeps`.
Then,
run `dockerfiledeps -emit-driver > driver.mk`
and start a `Makefile`
like
```make
REGISTRY_HOST := my.registry.net
REPOSITORY_NAME := project
include driver.mk

push-all: push-foo
  @echo done
```

You create your project repo
with directories for each target image,
where the directory name is the sub-repo name of the image.

When image `foo` descends from image `bar`,
start its Dockerfile
with `FROM my.registry.net/project/bar:local`.

Then you can `make push-all` and
get the Make goodness of minimal build times.
You can add rules for files in the various image directories
to speed builds, as well.
After all, `dockerfiledeps` is intended
to help and streamline Makefile writing,
not to completely replace it.

There are a number of
somewhat opinionated
but really helpful things
that `dockerfiledeps` also does.

The `dockerfiledeps` driver file
creates file proxy targets
(or proxy file targets...)
for a number of build steps.
For instance,
the `docker pull` steps
capture the resulting Docker id
into a file,
which gets updated if it changes.
The upshot is that you can depend
on these "proxy files"
and rely on Make tasks to run
if their inputs have changed,
but only then.

It captures git status data
and uses it both for Docker labelling purposes
(e.g. it uses the most recent git tag as a label)
and as `--build-arg`s to the Dockerfile.
You could, if you wanted
have your Dockerfile bail out
if the git repository isn't clean,
or simply record the clean status
as a Docker label.

If you have `pv` installed,
the output of Docker will
get piped through it,
so you'll have some sense
that the build is proceeding
without the Tank effect.

Keep in mind that the `driver.mk` file
is intended as a quick-start.
You can absolutely update it;
that's part of why
the `-emit-driver` mode
doesn't write to a file by default.
It's the `gcc -M` behavior
that we're really after,
and the driver file
is first and foremost there
to support using that.
Don't be afraid to
bring it up in an editor and change it.
This is your Makefile,
after all.

Please do let me know
if you get use out of dockerfiledeps,
or if you run across some deficiency.
Ultimately, because of how Make and Docker interact,
I'm almost sure there are situations
without an ideal solution.
They should all be fixable with Make rules,
though.
