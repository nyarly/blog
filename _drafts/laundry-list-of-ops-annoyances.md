---
layout: post
title: Laundry List of Ops Annoyances
---

Trying to identify the parts of ops work I don't enjoy.

Chains of identifiers:
variable points to a path
on a volume mount
from a named volume
that projects a config map
that has a field
produced from a resource file.
So so brittle.

Long cycles -
a one-character fix takes a minute to test.

The vacant mind state of "what else could be wrong?"
So much care to avoid mistakes.

So much state -
any process with live involvement is unlikely to be repeatable.
Or repeatable for a while,
and then fail for some reason.

Imperetive mode:
shell in,
look around,
run commands,
live edit config,
reboot services.
Kill your SSH session and drive to the DC.
But fixed was fixed, right then.

Well, until whatever it was caused the problem again.
i.e. the Cron Problem.
Something that only happens at weird times,
or when Our Revenue Service
has been running for a week.
Well, it used to be a week,
but now it's four days.
Let's put a cronjob on it to reboot automatically.
Or monit can restart it when it stops responding,
and forget about it.
There are philisophical zombies out there
who are okay with outcome.
