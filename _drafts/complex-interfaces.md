---
layout: post
title: Complex Interfaces
tags: [go, interfaces, engineering, techniques]
---

Go interfaces are
an extremely powerful and convient
language feature.
If you're unfamiliar with them,
the most compelling feature is that
they can be implemented without explicitly referencing
the interface type.
They look like this:
```golang
// the interface defined
type doer interface {
  do(string) (int, error)
}

// an implementation - note no reference to the interface!
type impl struct {
  x int
}

// the actual implementation of the interface
func (i impl) do(_ string) (int, error) {
  return i.x
}

func makeDo(d doer) int {
  i, err := d.do("hello?")
  if err != nil {
    panic(err)
  }
  return i
}

func main() {
  // impl can be passed as the doer argument to makeDo
  // just because it has a do() method with the right signature
  makeDo(impl{42})
}
```

You can pull lots of good tricks with this faculty.
For instance you can define an interface
that an existing _happens to_ fulfill!
The [testify](https://github.com/stretchr/testify)
package makes good use of this technique
to extend the standard library's `test.Test` type.

Keep in mind that,
Go does not have class-based inheritance,
so while interfaces provide
the subsitution part of clases
(i.e. you can pass any implementor as the interface)
they don't provide hierarchies of implementation
(i.e. you don't have a parent class to look up methods in.)

As is always the case,
the rule of thumb is to keep your interfaces small.
One, maybe two methods, not too many parameters each.
Which is a good rule, but sometimes the requirements
of the problem domain interfere,
and we need a complex interface.

How best to manage this thing?
We're assuming an interface with,
say, two dozen methods,
a few parameters each.
Different implementations may not
all do something with each method.

What's the best way to handle this?
As usual, presented with a hairy design problem,
no solution is unambiguously superior.
Let's review options
and consider their consequences.

First, let's describe an example interface:
```golang
type Complicated interface {
 A(int, string) (string, error)
 B(http.Request) http.Response
 /// ...
 Z(test.Test) (test.Test, error)
}
```

## Option 1: Embedded Null Implementation

While Go does not have inheritance,
it does have a different useful feature:
the anonymous embed.

The idea in this approach is
to have an implementation of the interface
where all the methods have a simple implementation,
and then embed that in our "real" implementations.

```golang
type ComplicatedNull struct {}

func (cn ComplicatedNull) A(i int, s string) (string, error) {

}

// also implement B-Z...

type RealComplicated struct {
  ComplicatedNull
  message string
}

func (rc RealComplicated) E(num int) string {
  if num > 3 {
    return rc.message
  }
  return "less than three" // this implementation likes you
}
```

Now, our implementations just override the methods they need to.
For cases where we need a complicated interface,
but where most implementations will only need a few meaningful methods,
this works well.
That circumstance is almost certainly a code smell, however.
Look carefully at how the implementation of methods happens -
where they change together, you likely could extract a smaller interface,
and restricting usage to those interfaces will
likely drive a better design.

## Option 2: Subinterfaces

The converse approach of the above

```golang
type Aer interface {
  A(int, string) (string, error)
}

func Wrap(me interface{}) Complete

func (c Complete) A(i int, s string) (string, error) {
  if me.(Aer) {
    return me.A()
  }
  return "", nil
}
```

## Option 3: Partial Embeddables
```golang
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
```
