---
layout: post
title: History vs. State
---

One thing that occured to me while driving recently was this: that a
fundamental issue with monitoring apps, as far as notifications go, is that
they hand off the actual notifications to other services. For instance, you get
emails or IMs or texts when something goes wrong.

Consider this commmon issue in monitoring applications. A service is being
monitored for responsiveness - in other words, the monitoring system attempts
to connect to the service, and considers it a problem if the connection isn't
acheived within some timeout. When this problem is discovered, it raises an
alert which becomes a notification. On the next check, the system discovers
that all as well and clears the alert. Sometimes, this also becomes a
notification.

For a given timeout, though, there's the problem that a server that's
experiencing moderate load may sometimes take longer than the time to reply.

...


The real problem is that we don't really want (usually) the complete history of
issues in the monitored servers. Nor do we really want alerts for every change
of state. We want to know the current state of our deployment, we want to be
notified about significant changes, and we want recent changes brought to our
attention when we review the overall state.

Jacked

Wave / Slack
