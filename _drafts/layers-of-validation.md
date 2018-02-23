---
layout: post
title: Layers of Validation
---

User enters data

SPA flags stuff out of range
  or that doesn't match a regex

SPA submits to API.

API enforces business rules.
Returns errors about business consistency.
SPA displays errors, guidance about correcting.

API updates database.
Database enforces data consistency rules.
Returns errors to API.
API returns errors to SPA.
SPA displays errors.

DB rules might be checkable by SPA.
Business rules might be checkable by SPA.
DB rules might be checkable by API.

SPA rule enforcement might overreach -
  rejecting otherwise good input.
Likewise API.

These problems of validation in layers
aren't restricted to SPA-API-DB scenarios.

Human involved in the feedback loop.
Feedback ASAP, but no sooner.

Validation definitions?
SQL has constraints.
(Although PL/SQL, "IMPORT LANGUAGE"...)
SPAs often have form validation little languages.
API should use a full GP language -
since that's its job.

Validation of validation:
do SPA rules match API match DB?
