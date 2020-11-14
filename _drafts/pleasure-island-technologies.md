---
layout: post
title: Pleasure Island Technologies
---

The sales brochure is that it will be a fantastic vacation on a remote island.

You get it installed initially, and for the first day everything is free cigars
and turkey dinners and a relaxing punch-up to wind down with.

Then, while you're shooting pool, you look around and you're a jackass.

In the Disney movie of Pinoccio,
the wooden headed boy
signs on to go to
Pleasure Island,
instead of going to school like he's supposed to.
Two fraudsters,
"Honest" John and his cat friend Gideon,
convince him that this will be much better.
Why waste his days with learning,
they suggest,
when he could be enjoying himself instead?
So he gets on the wagon,
where he meets his friend
Lampwick.
Together,'
they all go to Pleasure Island,
where they smoke cigars and shoot pool
and generally live it up.
Too late,
they discover that the curse of the island
is such that they'll be tranformed
in donkeys
to be sold on as pack mules or for circuses.
Eventually they'll all be drum skins.
Lampwick realizes this as he tranforms,
and his cries for his mother
are smothered in a donkey's bray.

There are
Pleasure Island technolgies out there.
The sales pitch might as well be delivered
by Honest John -
don't worry about learning how any of the stuff works,
just sign the contract,
deploy our best of breed tooling,
and you can be drinking and smashing stained glass
instead of drudging away.
The claims are often of huge work savings,
but long term,
you're the one who ends up a jackass.

When I first started writing this piece,
I had MongoDB in mind.
Rather than learn the arcane intricacies of relational algebra,
and certainly instead of needing
to design a well-reasoned database schema,
you could be building your database out already.
Just stuff JSON into a bucket,
and retreive it with a special query later.
And it's blazing fast!
Web-scale, even.
Trick is, much of that speed came from
returning from a query immediately,
rather than confirming even that
the server had acknowledged receiving the request,
much less confirming that the data was persisted.
And the effort saved
from avoiding defining a schema up front
gets chewed up quickly when
you need to build indexes on your data.
To get any kind of performance out of
queries on large datasets,
you need to index the fields you intend to search on.
The indexes become a kind of de facto schema,
except they're much less performant to compute,
and wind up locking up the database which they're created.

I have to cop to
the fact that it's been many years
since I worked with Mongo in any depth.
I note that the industry at large
has retreated from NoSQL,
however, and that Mongo doesn't seem
to come up in serious conversations any more.

Regardless,
the larger point stands:
there is a whole category of software projects,
many but not all available only through a costly license
that offer a miraculous savings in time and effort.
Often they claim to make something very complicated simple.
And in the end,
not only is the pitch
more pleasant than true
the ultimate costs will outweigh
the challenges posed by the traditional approach to things.

Our challenge, then
is to tease apart the claimed benefits
and winnow out the tradeoffs
_before_ we commit so completely
that we have floppy ears and a tail.
