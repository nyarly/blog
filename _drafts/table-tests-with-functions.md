---
layout: post
title: Table tests with functions
---

The idea of table tests
is by no means unique
to the Go community.
As far as I know,
they go back to
mid-90's Java.

But the idea holds a special place there,
in part because it explained
in one of the
[core articles](https://github.com/golang/go/wiki/TableDrivenTests)
on testing in Go.

Table driven testing
is the practice of describing
a list of test cases
with a list of lists of values.
Each item in the list is a test case,
and each value in a test case is
part of its definition.
For instance,
consider something like
```go
func TestAddition(t *testing.T) {
  testcases := []struct{
     a,b,expected int
  }{
    {2,2,4},
    {2,4,6},
    {38,88,111},
  }
  for _, tc := range testcases {
    t.Run(fmt.Sprintf("%d + %d = %d", tc.a, tc.b, tc.c), func(t *testing.T) {
      actual := add(tc.a, tc.b)
      if actual != tc.expected {
        t.Errorf("add(%d, %d) -> %d != %d", tc.a, tc.b, actual, tc.expected)
      }
    })
  }
}
```

In Go, the general idiom is to use
a slice of anonymous structs,
which means that we can then refer to the
variables that particularize
each execution of the test loop
by name.
Go's syntax makes the slice-of-structs
construction nicely ergonomic.

The value here is
in testing many different but related cases.
They're especiallly good for testing
pure functions,
because you often want to check that
particular inputs (often known tricky cases)
produce particular outputs.
It's quick and easy
to add new cases to a test,
as you discover new edge cases.
It's especially nice that you can see
all the parts of each test case
laid out on a line.
In other words, you can look at
```go
     {2,2,4},
```
and read that as
"2 plus 2 should equal 4".

Notice, however,
that in order to make that interpretation,
you need to have skimmed down
to the driver loop and found:
```go
      actual := add(tc.a, tc.b)
```

Without that, `{2,2,4}` could just as easily mean
"2 times 2 should equal 4"
or (less likely)
"2 is the remainder when 2 is subtracted from 4".
Without code to describe the test,
the struct itself doesn't actually convey intent.
While we might've named the fields
`summand` and `addend`, certainly.
I'd argue that,
while that's good practice,
it's not sufficient -
we describe behavior with code,
not with field names.
That works for this trivial example,
but most practical test cases
naming your test case fields
will not be sufficient
for a reader to intuit
what you plan to do with them.

The fields of our test case structs
are parameters to the driver loop, though.
What if we could put the parameters
and the code that uses them in the same place?
That sounds like a function to me.

Consider this alternative to the above:
```go
func TestAddition(t *testing.T) {
  addsCorrectly = func(a,b,expected int) {
    t.Helper
    t.Run(fmt.Sprintf("%d + %d = %d", a, b, expected), func(t *testing.T) {
      actual := add(a, b)
      if actual != expected {
        t.Errorf("add(%d, %d) -> %d != %d", a, b, actual, expected)
      }
    })
  }

  addsCorrectly(2,2,4)
  addsCorrectly(2,4,6)
  addsCorrectly(38,88,111)
}
```

There are a few things I like about this,
even in this very simple case.
Most of all, we name our test case,
and the name appears for each use of the test case.

Granted, we could name the table struct,
but then `go vet` complains about the anonymous fields,
and we start to lose a lot of the value
that concise table tests
give us.

With the use of `t.Helper`,
when one of our tests fail,
we can trace
the error message
directly to the test case,
rather than into the test loop.

For this example though,
I could go either way.
Table driven tests
are a legitimate technique,
and I can see
the whole test driver
with all its tests on one screen.
The friction to understanding
what the test does
and what it was meant to do
is minimal.

## More Complex Scenarios

Let's consider now,
writing tests for this code:
```go
func  Import(path string, srcDir string, mode ImportMode) (*Package, error) {
   // 500 lines related to importing code...
 }
```

Hard to go wrong plucking an example
from the Go source code itself!
This one is used by `go build`
to handle `import` statements.

We could build
a test table for this.
Something like:
```go
func TestImport(t *testing.T) {
  cases := []struct{
    path string
    scrDir string
    mode ImportMode
    expectedPackage *Package
    expectedError error
  }{
  // tdb
  }

  for _, tc := cases {
    // we'll come back to this
  }
}
```
