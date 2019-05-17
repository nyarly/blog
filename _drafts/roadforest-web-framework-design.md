---
layout: post
title: Roadforest - Web Framework Design
---

I've been working on a web framework,
a little at a time,
and in stints and long breaks,
for years now.
There's a draft client and server
implemented in Ruby,
but there's a lot I still want to do with it.

The general premise is like this:
you application exists as a kind of notional graph,
of the kind composed out of nodes and edges,
and is transmitted between entities
as Fielding-style REST resources
that contain subgraphs of the larger whole.

A client develops a kind of understanding of the overall state
by retrieving resources that are parts of the over web,
and following the links out of their existing knowledge of the graph
when they need to.

A server maintains their part of the graph,
interlinked to the graphs of of other servers,
in a very simple HTTP GET/PUT kind of a way.
Resources served describe overlapping sections of the graph,
with some parts of a resource being authoritative in the response,
and other parts being "front-loaded" references to other resources.
Every edge has exactly one resource that is authoritative for it,
but any resource can provide extra edges.

Consider, for instance, a list of items:
there's one resource that is the list itself,
and links to all the of the items
(the hyperlinks themselves are nodes in the graph)
but can also include a subset of the information about each item.
Many clients, then, don't need to retrieve the items,
since the in-list summary is sufficient.
But the those extra edges
(that connect to the name of the item,
for instance,
or a last-update timestamp)
can also signal to a client that it needs to re-retrieve
an item resource who's representation it relies on being up to date.

The exciting result of this kind of approach
is that client and server framework code
can do a lot of intelligent things for the developer.
For instance, by describing the kind of data you want
to the client framework,
you can then lean on the framework to follow its nose
and produce the requests you need to get that data.
And then, to keep that data up-to-date
and drive UI changes into the bargain.

On the server side,
you can describe the individual resources,
just the authoritative parts,
and rely, perhaps, on the server
to include the parts of other resources
that will minimize the amount of requests clients need to make
to get the data they need.

All this leans heavily on
various web standards,
including HTTP,
but also the Resource Description Framework.
(Often, RDF gets a bad rap,
I think because of its early association with XML.)
Within RDF, the edges between nodes in the graph
have universal definitions -
they come from vocabularies that are usually referenced
in their URI names.
A happy consequence is that RDF based HTTP resources
can refer meaningfully to resources on different servers,
and in ways that clients can make sense of.
