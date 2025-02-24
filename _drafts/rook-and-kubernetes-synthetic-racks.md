---
layout: post
title: "Rook & Kubernetes: Synthetic Racks"
tags: [operations, engineering, kubernetes, rook]
---

This was a proposed project at work
that won't make it to the head of the queue, now.
When we were first considering this,
the Rook and Ceph experts we were talking to
said they hadn't heard of anyone doing this,
but it seems like a straightforward approach.
￼
The goal here is to get the best
of portable OSDs and failure domains. Currently, when a node cycles,
we expect there to be brief storage outages as OSDs migrate. Volume mounting
or placement problems might delay that process.

The scheme here is to establish artificial "racks."
Racks would just be imaginary -
effectively an arbitrary "team" that each Node in the Kubernetes cluster
is assigned to when it's created.
We can then treat these synthetic racks as
Ceph failure domains.
Ceph should distribute OSDs across racks,
and if we lose a single Node, all the OSDs
on it will be gauranteed to have replicas on other Nodes.

To accomplish this,
we'd use Kyverno policies
to add "rack" labels to each Node
as it enters the cluster.
Kyverno has a facility to use external data sources
when applying policies.
There'd be a Kyverno policy that would modify Nodes
to add the appropriate label,
querying a rack-counter service for the smallest rack name.
The result should be Nodes allocated roughly evenly to different racks.

The idea here would be to have a simple service that
lists and watches Nodes,
and counts "rack" labels against a list of racks,
and keeps track of the least-common rack.
The counter would also serve as a monitoring endpoint:
we'd register warnings when the rack counts
skew by more than 1 (or maybe 2),
and full alerts for empty racks or extreme skew.

Now,
when we have Node outages,
either because we roll our Node pool for upgrades,
or due to auto-repair,
we'll know that all the OSDs on any one Node have replicas
on different nodes,
and that no replicas co-exist on a Node.
