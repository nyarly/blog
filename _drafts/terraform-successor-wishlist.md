---
layout: post
title: Terraform Successor Wishlist
---

I mean, HCL can die in a fire.
It's the PHP of IaC.
The nicest thing one can say about HCL is that it isn't YAML.

Loops?
Because why would you want
more than one resource group with related configuration?

Conditionals?
Because why would you want
alternative configurations based on inputs?

Always fun to malign
the syntax and semantics
of a language you've spent years wrestling with.
But more ink has been spilled about HCL than I want to waste here.

Okay, but one thing is the failed orthagonality of modules in Terraform:
do I use them to mark out a feature of my infrastructure?
Or to loop over?
If I need a loop within my feature,
(but also need common infrastructure for each instance)
do I make a sub-module for the looped stuff?

The real issue is that
the core model of Terraform is broken,
and can't be fixed.
The majority of my issues with Terraform arise from its
provisioned <-> statefile <-> configuration
model.

Somewhere in here is:
The core mental model of any IaC is that applying your
code to your infra successfully
should lead to a consistent state,
regardless of the previous state.
Just encountered a situation where an imported Vault
accepted a plan/apply,
but a fresh Vault failed with a re-used auth path.

There's clearly an impedence issue between
resources as Terraform defines them
and actual infrastructure.
Frequently,
we find places where the real world
doesn't fit in a sensible way with the resources defined.
For instance,
vault_jwt_auth_backend conflicts with vault_auth_backend,
whereas the latter is used everywhere else with different types.
Bad provider design?
Or is the design of Terraform too anemic to fit the needs of Vault?


Secret management, full stop.
"Keep your state backend secure"
is a terrible thing to have to put in docs,
and I'm suprised that whoever wrote that didn't dissolve into
their own soup of embarassment.
Between providers and variable declarations,
we should know which values are sensitive,
and hash them for comparison.

If `sops-nix` can solve the problem of
keeping secrets in a deterministic deploy system,
you can.

Do state comparison by values of hashes, rather than values directly,
and the state stops being a toxic security liability.


Moves - https://github.com/hashicorp/terraform/issues/33236
It's impossible to wholesale move resources from "under" a for_each.

Moves are awful, and needful.
Consequence of "sync" based resolution.
Unique IDs in config?


Related resources -
e.g. "common infra" (DB, networking)
and consumers e.g. individual applications with common templates.

Terraform model - single state,
but also "smaller deploys" - folk segmentation/sharding

No way for TF to map between deployment groups,
or identify overlapping/shared resources
(Unique IDs...)


Sophisticated lifecycles
GCP Projects: "dont destroy" - just forget them -
possibly, re-adopting them when they reappear, rather than requiring `terraform state` manipulations
before-before rather than bracketing for certain dependency sequencing

More scrutiny on providers:
post-apply, always re-sync state and report errors if it varies.
Type system that allows for anything needed by providers:
ordered maps,
bags, sets,
custom canonicalization.
It should be easy for providers to report/compare infra state
such that an unchanged infra is always reported as a no-op,
and hard for providers to avoid bug reports when they don't.

Likewise,
provider errors should be consistently formatted
such at (bare minimum)
`tf import mod id` is brainless to write,
because the module and id are printed in the case of an error.

Admit the messy state of infra:
built in tools for import, moves, migrations
well beyond "you can manually write it all up."
Resource IDs should make moves nearly trivial to automate.
The 3 way sync should make it easy as well.
Tooling around "there are resources I can see that aren't in your config"
would be ideal.
IOW, 3rd party terraform support tools should be a badge of shame for the design team.
