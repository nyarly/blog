---
layout: post
title: Shape Expression Maps
---
= Shape Expression Maps

Some time ago,
I started working on
a Ruby implementation of
an extension to
Shape Expressions
for
RDF
called
Shape Expression Maps
(or ShexMaps for short.)

The original design of the extension,
and an ECMAScript implementation
were produced by Eric Prudheuameux.
Errors or misapprehensions here are my own.

Let me start with a short prequel.

== RDF

The Resource Description Format
is a specification of an abstract data format
for representing basically anything
as a directed graph,
where non-leaf nodes
are either unlabelled,
or labelled with a URI,
where all edges are labelled with URIs
(and further described in linked documents called "Vocabularies")
and data at the leaves can be well typed.

RDF is the basis specification
for many other data formats,
including Facebook's
OpenGraph,
microdata,
and many other, more obscure formats.
There's amazing potential for interoperability and reuse
presented by RDF,
and it excites me personally as a web engineer.

In passing,
I'll mention that RDF often gets a bad rap
as being an XML format,
which is a kind of consensus ignorance.
RDF was developed at a point in time when XML
was how structured data was represented,
and RDF-XML was very common at the time.
There are many more concrete formats
for embedding RDF,
including JSON based ones, if that's your fancy.

== Shape Expressions

RDF is incredibly general, however,
and the formats of data modelled with it can be difficult to communicate.
There are a number of mature efforts to formalize a standard
for representing the structure of RDF documents.
My personal preference is Shape Expressions
or ShEx.

Roughly speaking,
a Shape Expression describes
a pattern which documents must match
in order to be considered
conforming.
Expressions can include variables,
which work analogously to
regular expression captures:
if a document matches a shape expression,
then a tuple of pairs can result,
associating variable names with
the data or nodes of the graph
that are matched by the variable.

The Shape Expressions standard
admits to the possibility of extensions to the basic format,
so that indivual parsers and producers
can implement extra features
and represent their support for those features.

== Existing Work

The definitions for Shape Expression Maps
describe how two shape expressions
with a similar set of variables
can be used to map
RDF documents that conform to one expression
into documents that conform to the other.

Boomerang & Lenses

== Properties We Want

We'd like to be able to recognize a well-formed Map.
That is, a Map that has the properties of a well-formed Lens.
So: putback, set-get, etc.

Also: annealled round-trip.
That is,
we accept that, without putback,
mapping back to the original expression
may result in a subset of the original graph.
But, if we take that subset
and round-trip again,
we should return to the first result graph.


== Implications for Intermediate Representation
