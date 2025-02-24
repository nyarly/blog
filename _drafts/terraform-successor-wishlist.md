---
layout: post
title: Terraform Successor Wishlist
---

I mean, HCL can die in a fire

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
