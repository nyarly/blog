---
layout: post
title: Functional Table Tests
---

Instead of

cases := []struct{ A, B, C }{
  struct{ 1, 2, 3 }
}

TestTable(t t) {
  for case := range cases {
    ...
  }
}

Try

TestTable(t t) {
  case := func(A, B, C){
    t.Run( ... )
  }

  case(1,2,3)
}

Also good:
instead of conditionals in your for loop
(if expectedError != nil)
you can have
errorCase := func()...
happyCase := func()...

Basically, if you're table testing,
never have conditionals in your loop,
is what I'm saying.
