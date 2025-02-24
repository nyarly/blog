---
layout: post
title: 'Design: Archon'
---

Concept for a declaritive Kubernetes operator engine

Built on the idea of assembly graphs

Rust engine, Nickle configuration language.

Define resources as Nickle functions, with functions to extract values from their output.

Engine consumes the configuration, establishes list/watches etc.
If a partial version of the graph is detected,
(simple case: root CR without anything else)
determine next set of resources, and create them.

Use ValidatingWHC to enforce contracts;
consider also how CEL figures in.

From recent TF experience:
the "delete" behavior may require an extra phase on assembly graphs:
where code building need `depends_on` and `before` relationships,
IaC needs `create_if`, `destroy_unless`, `create_before` and `destroy_before`.
The default A -> B is create_if(B,A), destroy_unless(A,B), create_before(B,A), destroy_before(A,B),
but there are times where those relationships needs to be more carefully controlled.

Some operations will require a Job of some sort (i.e. to initialize Vault)

Some operations will require a Job (or other executable) to report data to the controller,
which will need some means of collecting data
in a space "parallel" to the Kubernetes resource database.
Or! reported data goes into a configmap/secret that the engine consumes.

Names need to be parameterizable -
A CR named "foo" should produce e.g. Deployments named "dep-foo."
Related, JSON blobs need to be keyed in a parameterized way.
