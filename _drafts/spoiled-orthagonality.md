---
layout: post
title: Spoiled Orthagonality
---

CS degree - orthagonality and engineering
x/y control, the cartesian plane
"Skew"

Go "optional" fields -
Use null
But useful zeros?

Terraform modules
Group features
Unit of loops

As an author (thinking about CSS parlance)
I'm caught between the two alternatives.
I can e.g.
use pointers in my Go JSON DTOs,
and let omitted fields be null,
but now I can't use the zero of the DTO usefully.
Or I can use concrete fields,
use e.g. "" or 0 when omitted.
Now the zero is good,
but I can't reason about the server response
based on the DTO.

Petty example:
directory structures in software systems
is it kind/feature or feature/kind?

The designer of the system
(it seems)
re-used a feature for two separate but "skew" purposes
which seems to make the system simpler.
For the designer and implementer,
it certainly does:
for whichever is the "new" requirement,
the work is already done!
Or nearly so.
We just need to document the application of the feature!
And make it a principle of our ecosystem community.
For new learners,
there's one less concept to learn.
But for authors
(who outnumber the other 3 groups
intuitively because they _include_ the other 3),
the problem of how to resolve that skew will recur
over and over while they use the system.

Counterpoint:
(and while I'm thinking about the W3C's docs about CSS)
CSS `transform` and `animate`
_could_ have been one feature set -
`transform` - `animate` is hover events.
So if CSS had allowed for behavior that triggered animations,
it would have been just one feature.
My understanding is that
the two features were developed separately,
and that there
were concerns from browser teams
about efficiency and responsiveness
if they were merged.

Principle of design then:
Consider carefully the reuse of a feature.
Will the system behaviors it enables ever be needed simultaneously?
Will authors be forced to choose between ways of employing it,
and supplimenting the behavior they sacrifice as a consequence?
Will the feature's use explode because it has to be applied
to alternating purposes?

Bigger picture: general purpose systems
need to be designed with a holistic view.
Their Big Design needs to be Up Front.

Bonus skew systems:
Github Actions - reusable workflows vs custom actions
Github Actions - custom actions: composite vs docker vs JavaScript
Basically and CI with reusable task definitions, it seems like
