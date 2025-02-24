---
layout: post
title: 'Design Doc: Workspaces'
---

Time for a next-gen direnv

direnv is a great tool
can't do unload hooks.

# Requirements

Unload hooks
development servers
background processing

# Design

Take the basic features of direnv:
Digesting, watching files,
"allow" for config & friends (e.g. `direnv edit`)
PS1 hooks
Bash-export as interface? Hacky, but kind of good.
Certainly (and this is always the argument)
a least common denominator for development tools.

Add: an as-needed daemon, _a la_ Tmux
`workspace export` either receives a PID, or looks for a shell in its own ancestry
daemon registers PIDs as "using" a context (by default: a directory)
daemon watches PIDs - when the last user of a context exits,
unload hooks get run

Which implies:
`workspace on-unload <script>`
which itself needs design.

Daemon also needs to be _involved_ somehow is managing other daemons,
so that we can start development servers and keep them running.

Backgrounding:
`workspace export` messages the daemon,
which runs the .workspace file to set up.
If that takes more than 100ms,
return the cached version
(or a message about "new build, be patient")

Implies snapshot/stream events, for shell and notification.

Which wants some UI, as well:
a prompt formatting utility (`workspace prompt "glyphs"`)
and an executor (`workspace on-event "script"`) so that notification can happen.

Dependency sequencing?
Or single config file, and tooling so that "sequenced" things
can be run.

Resource tracking: `workspace list` -
all the state directories, running daemons, etc etc.

## Other Daemons

One option: not our problem. User must set up a userspace systemd unit
(or similar)
and use hooks to `systemctl --user postgres@$MYPORT start` and `stop`
Downside: a lot of extra setup,
but developers should do their own workspace config

Something like acting as init,
and optional starting a single process for the context
so that you could start a runit or sk6 or something.
Nicely flexible on a per-project basis

Design dillema of per-user service management
vs. per-context.
For `runit` and friends, probably doesn't matter.

Worst option: daemon acts as its own service manager.

## Unload Hooks

When all of a context's users die, its unload hooks get run
Run unload hooks in reverse order of registration,
each unique file run exactly once
Log their output to the context's state directory

## Contexts

Open question: do we need contexts != to directories?

Pro:
shared resources e.g. development servers

Con:
complication of the design and usage
might be minimized by a concealed feature

## Context Resources

Each context gets a state directory under $HOME
(somewhere in XDG etc)
Available under an envvar
usecase: dev postgres state dir

## Utilities

`allocate_port` to find a free port and put it in envvar
```
export PGPORT=$(allocate_port --tcp 5432)
```

# Use Cases

## vs. Lorri

On the order of
`source $(nix print-env .#)`
(or the analogue for nix-shell)
Some wrinkles for pinning GC roots, but that's not so bad.
Watching files that `nix` depends on....
Maybe now we rise to needing a utility...
...which is small and single purpose enough to be generally useful
