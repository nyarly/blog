---
layout: post
title: Extract to Library
tags: [software, practice, Libraries]
---

Identify useful behavior
If not implemented, implement in consumer.
Isolate behavior with interface package/class.
Create library.
Local linking.
Move behavior to library.
Test original consumer
Built tests for library inspired by consumer.
Mark as 0.0.1
Document
  describe library
  document API - keep in mind semver
  README
Push live
Change original consumer to use shipped version
Test again.
Use in a second project
Maintain
