---
layout: post
title: Programming Away From Text
---

Ultimately,
all computer programs compile into machine language.
{wtf is that?}

On the way,
text is parsed into syntax trees,
before being actually compiled.

`gofmt` parses and
then round-trips back to text
to produce a canonical form.

From time to time,
there's discussion of programming directly
in the syntax tree.
Snap together programming systems
like Sketch
are effectively this.

Working programmers,
are much more efficient,
though manipulating text with a keyboard
than they are clicking and dragging stuff around.
{subjective, no?}

What if
a hybrid system.
Much like how we use code completion,
where our editor or IDE watches our text input and
suggests the next thing and then enters that text automatically.
Instead,
prefixes (or ongoing fuzzy search)
matched against language structures,
and the structures are the objects actively recorded
and ultimately stored.

What would we get?
Much like modern advanced type systems,
more correct programming up front.
Many features of the modern development environment
mimic the benefits of such a system.
Consider live syntax checking -
little warnings that your code might not parse -
but instead it would be impossible to input unparseable code.

Vim style "text objects" only more so -
navigation based on the actual syntax tree,
rather than a parallel parsing of the tree.

Snippets, but more so.

Tree diffs based on the tree-as-intended
instead of
textual diffs or
tree-as-interpreted.

Tree-aware version control.
