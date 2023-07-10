---
layout: post
title: The Whole State Problem
---

Deploy as a whole state isn't treated as a gold standard
Cross-team coordination is hard
State maintenance becomes expensive
e.g. Terraform discourages this

Deployment is treated as a piecemeal activity
e.g. Deploys per-microservice or component

Why whole state deploy?
DevOps practice of identical environments
Deploy _same_ artifact to staging and prod.
Partial deploys aren't same in both environments -
how can you draw reasonable conclusions for acceptance
from partial staging deploy?
