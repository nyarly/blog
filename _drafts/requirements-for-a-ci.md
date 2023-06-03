---
layout: post
title: Requirements for a CI
---

* few "options" - think crypto protocols
* not opinionated - every opinion breaks a build

* nice UI over simple primitives
  * don't hide primitives
  * Pine "expert" mode

* workflow definition
  * reusable steps
  * depgraph with "control-board" exposure
  * API defined?
  * data managment - inputs and outputs
    * subtask outputs->inputs
* a worker pool
  * run & re-run
  * concurrency control
  * easy self-hosting
  * broad range of granularity (v small jobs - v large)
  * manual & automatic retry
* secret management & artifact storage
  * public forks
  * delegated actions
  * automatic caching
  * easy, flexible fetching
  * authz on access
  * outside providers (e.g. deliver a secret)
  * how provided?
* checks & gating
  * inspect test results
  * trigger/inhibit runs based on checks
  * manual gates (= dynamic controls - a job can add a new button)
