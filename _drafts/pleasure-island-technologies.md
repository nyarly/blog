---
layout: post
title: Pleasure Island Technologies
---

I refer sometimes to the idea of
a "Pleasure Island" technology.
It's a useful metaphor,
and comes up in discussions about stack selection.
More accurately,
the idea refers to an anti-pattern
when we're choosing our tools.
Some choices seem like great ideas up front,
but longer term, they'll wind up costing us.
The unpleasant surprise can be quite severe,
and usually that's in proportion
to the magnitude of the promised benefits.
The extreme cases,
I've come to shorthand as
Pleasure Island technologies.
To explain why,
let's start be establishing
a common understanding.

## A Parable

In the Disney version of Pinocchio,
the wooden headed boy,
instead of going to school like he's supposed to,
signs up to go to
Pleasure Island.
Two fraudsters,
"Honest" John and his cat friend Gideon,
convince him that this will be much better.
Why waste his days with learning,
they suggest,
when he could be enjoying himself instead?

So he gets on the wagon,
where he meets his friend Lampwick.
Together,
they all go to Pleasure Island,
where they smoke cigars and shoot pool
and generally live it up.
Stained glass is smashed,
whisky is drunk,
and crowds of boys,
left to their own devices,
basically misbehave.
It seems like a grand time!

Too late,
they discover that the curse of the island
is such that they'll be transformed
into donkeys
to be sold on as pack mules or for circuses.
Once their usefulness is exhausted,
they'll all be rendered down as drum skins.
Lampwick realizes this as he transforms;
his terrified cries for his mother
are smothered in a donkey's bray.
Pinocchio flees,
and escapes the island,
but not before sprouting floppy ears
and a humiliating tail.

## The Metaphor

There are
Pleasure Island technologies out there.
The sales pitch might as well be delivered
by Honest John -
"don't worry about learning how any of the stuff works,
just sign the contract, "
(or fork the project -
more than a little of this stuff is Open Source!)
"deploy our best of breed tooling,
and you can be drinking and smashing stained glass
by the end of the day
instead of drudging away
reading references,
doing extra work."

Everything is going to be effortless,
elegant,
inexpensive
and _fun!_

But in long term,
you're the one who ends up a jackass.

## For Instance

When I first started
talking about this idea,
and writing this piece,
I had MongoDB in mind.
(No one can accuse me of a rush to publish!)

Rather than learn the arcane intricacies of relational algebra,
and certainly instead of needing
to design a well-reasoned database schema,
you could be building your database out already!
Just stuff JSON into a bucket,
and retrieve it with a special query later.
And it's blazing fast!
Web-scale, even.

Trick is, much of that speed came from
the client libraries
reporting an immediate success
from insert queries,
rather than confirming even that
the server had acknowledged receiving the request,
much less confirming that the data was persisted.
Queries could be quite fast...
if they could use defined indexes.
To get any kind of performance out of
queries on large datasets,
you need to index the fields you intend to search on.
The indexes become a kind of de facto schema,
except they're much less performant to compute,
and wind up locking up the database while they're created.

In the end,
you wound up having to plan a schema anyway,
and turn on commit confirmations
(for each query!)
And then it almost performed as well as PostgreSQL.

But to get that experience directly,
you had to commit to Mongo as your data store.
Now, your whole product runs on it,
and migrating out
to a SQL database
is going to be a major project.
You're trapped on Pleasure Island,
and starting to feel a terrible bray building behind your teeth.

# Evergreen

I have to cop to
the fact that it's been many years
since I worked with Mongo
very seriously.
I note that the industry at large
has retreated from NoSQL,
however, and that Mongo doesn't seem
to come up in serious conversations any more.
Maybe there's some cause
for optimism that we collectively learn from our mistakes.


Progress is possible.
New things can be good.
It's not all "the old ways are best"

Just as we should be skeptical
of claims that we can buy a ticket
to an island where there's free booze
and we'll never have to work again,
maybe we should exercise that skepticism
about supposed benefits of computer technologies.
Maybe things that sound too good to be true, are.

Maybe, for instance,
we can't completely subvert governments
by trading random numbers instead of printed bills.
Maybe,
we can't replace human expertise entirely
with the thickest book of Mad-Libs ever invented.

To examine those ideas, though
we need to dig into the fundamentals of the problem.
Mongo's Honest John pitch was
"all those schemas, and centralized computing
_isn't necessary"
and we could look at that and wonder
what Edgar Codd was up to.

This claims can get us to think deeply about things like
"what is a schema for?"
(and that can be a really rewarding line of investigation!)

"There was no point to the traditional approach"
is a big red flag.
Often, they just don't understand what the point _was,_
which should lead us to question
their solution that ignores that part of the problem.
Figuring it out for ourselves,
we can get more value out of the traditional -
for instance, using DB schemas as a way to communicate between teams -
or better appreciate new solutions that do address them.

For instance,
schemas _are_ important,
but there's been a lot of success recently
moving from centralized servers
to Raft/Paxos based clusters.
c.f. CockroachDB.


Regardless,
the larger point stands:
there is a whole category of software,
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
and winnow out the trade-offs
_before_ we commit so completely
that we have floppy ears and a tail.
