---
layout: post
title: Semantic Distance, Layering
---

Twitter conversation with Pat Maddox and Alistair Cockburn.

Judson
Trying to think how to phrase what I wonder if isn't already an established
software design principle.
 Judson
Given two components at the same level of abstraction, their interactions
should be with the same levels of abstraction - ideally "one down"
 Judson
e.g. if I've got a thing that talks to the ORM, it's sibling shouldn't be
grabbing DB connections.
 Pat Maddox
 I like it. I don't know of a name for that. Maybe  would have an idea...
 Judson
  Like, I think there's a metric to be had of objects talking to each other in
  ... semi-cliques? Where semiclique..
 Alistair Cockburn
  Sounds like a good idea. Don't know of a name, understand the concept, could
  be hard to define levels
1 retweet 0 likes
 Judson
  If you've got a Big Ball of Mud, then one big call graph - every unit
  (potentially) sends msgs 2 every other
 Judson
  If you had two BBMs, two such graphs. If one is a layer above the other,
  edges go from on to the other but not vv
 Judson
  Other extreme is a unidirectional line - one unit calls down to the next,
  only.
 User Actions
Following

Pat Maddox
  fwiw the name that pops to my mind is Weirich's "connascence" – but I don't
  think that's what he meant by it

Pat Maddox
  & I have to admit that I never actually understood what he meant by
  connascence. so I'm wanting this to fit :)
 Judson
  Wikipedia's article is pretty good. More detailed examination of coupling
 Alistair Cockburn
  1st do call graph. but what you want are semantically similar class names in
  layers. that's the hard part
 Judson
  Do I get you: you're saying that, having identified layers, you want the
  names of classes to tag their layer?
 Alistair Cockburn
  you want to measure semantic distance between calls
1 retweet 0 likes
 Judson
  Defined in what terms? Lexical distance?
View other replies
 Alistair Cockburn
  Semantic distance. You're the one with the request... I only said it's hard.
0 retweets 1 like
 Pat Maddox
  I like where this is going. I think before getting into the principle ("X
  should...") it's important to
 Pat Maddox
  investigate the property. "semantic distance" as a property. What happens
  when SD increases within an object?
1 retweet 0 likes
 Pat Maddox
  what happens when SD is more-or-less the same within a cluster of objects?
  when it differs?
 Pat Maddox
  after investigating the property and its outcomes you might get closer to a
  helpful principle...
