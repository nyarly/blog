---
layout: post
title: Will the last deploy of ReiserFS please turn out the lights
---

Upshot: I think reiser was making my linux box slow.

I was having lots of problems, and did learn systemtap to remediate them.

But switching from Reiser to BTRFS seems to have solved them.

Sadly, Karl Reiser being a murderer killed the devlopment and interest in ReiserFS,
or might have seen more development, and these issues might not have arisen.

Anecdotal: noticed _so many_ filesystem events using `fswatch` which may
help explain the fsync behavior.

I can't say for certain:
I've neither the time or inclination to drill into the root causes here,
but if anyone else is looking for information about reiserfs,
it may help them to know that at least one other person had problems with it.
