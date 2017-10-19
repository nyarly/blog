---
layout: post
title: Complex Interfaces
---

In Go
interface with several methods
not every implementation does something meaningful with every method

option 1:
the embeddable null implementation

option 2:
the complete implementation, subinterfaces
Wrap(me interface{}) Complete
Complete.A()
  if me.(Aer) { me.A() }

option 3:
partial embeddables
type X interface {
  A()
  B()
}

type DoesntA struct {}

func (DoesntA) A() {}

etc.

type Me struct {
  DoesntA
}

func (me Me) B() { ... }


