---
layout: post
title: A Universal Kubernetes Operator
---

## Motivation

The inspiration is this:
Operators in Kubernetes take a CRD,
and run a reconciliation loop
to effect the (human) operator's intention.
The reconciliation is supposed to be
a sequence of small changes,
each checked to be successful before moving on.
That makes the loop a lot like a build process.

When I was looking a build systems
(c.f. Mattock and Ergo)
I came to the conclusion that they can be
represented as a pair of graphs
with an intersecting set of nodes.
The nodes are build products.
The edges of one graph describe which products
need to build built as a consequence of needing other products.
I call this the Also Graph, because
e.g. if we need the object file, we _also_ need the C source.
(paraphrasing the classic Make motivation example.)

The other graph represents the relationship between
products in terms of order:
if we need the object file and the C source,
the object file somes after the source
(because we need the source to compile into the object.)
So the second graph is the Sequence Graph.

These might seem redundant,
especially when we consider the Make example,
because Make treats these two graphs effectively
as the same sets of edges -
every "also" is also an "after" edge.
However,
(I wish I had references to other work recognizing this)
many build processes require different relationships
between their products -
I need A "also" B, but B "after" A (the arrows flipped)
or even cases where one product implies the need for another,
but without sequencing allows parallel builds.

I really like this model of a build system,
and it occurred to me it could be used to describe
how an Operator would function as well.
Skipping the detailed design motivation,
here's what I'm thinking:

I'm starting with this assumption:
that an operator can function solely
by inspecting and creating Kubernetes resources.
If not, if an operator needs to do more than this,
we can limit the "extra" functionality.

## A Design Sketch

I want to build it in Rust, because I want excuses to write Rust.
We need to be able to describe the _form_ of resources
without describing them literally.
I reject string templates for this purpose.
Nickel is inspired by Nix,
and written in Rust, so seems like a good choice.
Not only can I describe Resources,
I can use it for whole-system configuration.

The idea would be to deploy our tool
(which needs a name)
with a ConfigMap holding its Nickel configuration.
The tool would examine the nodes in its graphs
and start watching lists of appropriate resources,
and using that to drive the build process.
As alternatives,
it could create its CRDs (if missing) on deploy,
or simply await their creation,
perhaps updating the ConfigMap so that a human
operator could pull them down and apply.

A given root of an Also Graph
implies a target state
that includes the nodes reachable
from that root.
Each node is really a template Resource,
and edges of the Sequence Graph
embed functions to extract data
from existing Resources and provide them
to templates to make them concrete.
The Sequence Graph also constrains
what updates the operator takes to convert
the subset of concern of the overall Kubernetes state
into the target state.

One gap that needs filling involves manipulating
the running processes inside of our Pods.
Most useful operators embed knowledge of how to run
the service(s) we're trying to stand up,
and some of the sequencing we care about
is going to invole the states of those services.
For instance, we may want to wait for the DB schema to be created
before starting the client service.

So I think this is the exception we need to only-Kubernetes-operations:
for resources _owned_ by our operator (i.e. CRs)
we need a way to collect the Status field
(which we would also be responsible for.)
By default this might simply be "the direct successor resource statuses",
but something like a Service definition whose response
is copied to the Status field when it changes.
Now, we can deploy that e.g. as a sidecar or separate deployment
and then watch the status for updates.

For our DB schema example, we create a CR for FooServiceDBSchema,
and let it run pgsql commands and write a little report,
leaving an nginx in place to serve the report,
and copy the report as the Status on the Schema.

We see here that we'll not merely need to wait for a pre-defined
"Ready" state, but for the form of the resource to match
some shape.
Nickel allows for contracts, which we can check against our Resource,
and functions to extract data from it.
Our resource nodes, or sequence edges might therefore
describe not just e.g. a unique named resource,
but a particular state or version of that resource.

If, in the course of operations,
we need to do one-off executions,
Jobs are right there.
They do give rise to a new requirement:
that the path to our target state not always be
one of monotonic addition.
Sometimes, we will need to delete, or wait for the deletion
of a particular resource.
Effectively, we have a sequence edge that runs from A to B,
and demands that A is _absent_ or terminating.
Alternatively, B might represent an absence -
implying that once the sequece from A to B is satisfied,
B-but-existant should be deleted.

## Considerations

Would the juice be worth the squeeze?
In other words, would it be easier to write a bunch of Nickel
to describe the operation we want managed
than to build a bespoke operator?
There are frameworks to help manage the reconciliation loop,
and we'd probably want to take advantage of them for this tool.
I'm going to pass over
the "ew, a new language to learn" objection.
If writing a blueprint for a operation is easier
that building an operator from scratch,
learning Nickel would be worth the effort.
After all,
learning Make was worth it,
despite shell scripts existing.

I think there would be value to isolating the considerations of the authorship process.
I envision an author sitting down and saying
"Here are the resources I need built, ultimately."
From there, (and especially if Nickel had tooling to translate from YAML)
anding a function header and rewriting literal fields and variables is straightforward.
Now, we need to source those values,
and either we know where to look in the cluster,
or we need a new custom resource.
In either case, we write a "before" clause,
extracting the variables from the precursor.
If we need data from inside a process, we build a little program to extract it,
and a "status" clause on a custom resource node.

In other words, I think we have a process here that guides us,
breaking the overall problem into many manageable steps,
and limits the decision space without overmuch limiting the power of the tool.
By using a structured language (like Nickel) we control a lot of sources of errors,
and we can produce first drafts of our CRDs.

That does raise an issue: neither CRD contraints nor Nickel contracts
are pure supersets of one another.
We might be able to take a contract for a custom resource
and express some of it in OpenSchema + CEL,
but we might still be able to submit CRs that would fail the contract.
Likewise, if we augmented the CRD by hand,
there would be CRs that would pass the contract
but couldn't be submitted.
This isn't a unique problem:
a handrolled operator also has potential resource descriptions
that fall in each section of that Venn diagram -
this tool might be able to exclude the lobe that is
"Kubernetes rejects it, but we would accept it."
On the other hand, a handrolled tool might be able to
eliminate accepting invalid resources.
On reflection, the whole problem is very knotty,
and we may have to live with Nickel contracts and see how they do.

### The Name Game

Finally, and maybe most important,
I don't have a name or nominclature for this system.
With the idea that it's a "universal" operator,
I've toyed with "Launchpad"
(i.e. a reference to a Disney property - the logo might be difficult)
or some other pilot-of-anything.
Given that there are blueprints or other structural designs involved,
maybe "contractor" (or that theme) would be appropriate.
In keeping with Kubernetes greek roots,
"Daedalus," the mythic archetect is interesting;
of course, an archetect would be doing the design itself,
rather than building to plan.
Finally, given that there's an order of operations,
something like Pemdas or Łukasiewicz appeal.

From there, there's the question of what to call
the Nickel-filled ConfigMaps used to drive the whole process.
"Flight manuals," or "blueprints?"
"Structure graphs?"

I know I'm going to be coming from a pretty high-flown place.
Discussions of sibling graphs over templated nodes
written in a lazy functional language might appeal to _me,_
but might be offputting to a lot of DevOps folks.
Launchpad ("make your Kuebernetes fly!")
or Pemdas ("take control of the order of operations!")
have the appeal of being more familiar,
and relating, what I hope, is a democratizing goal.
