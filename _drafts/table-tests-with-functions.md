---
layout: post
title: Table tests with functions
---

Tired:
```
func TestAddition(t *testing.T) {
  testcases := []struct{a,b,c int}{
    {1,2,3},
    {2,4,6},
    {38,88,111},
  }
  for _, case := range testcases {
    t.Run(fmt.Sprintf("%d + %d = %d", case.a, case.b, case.c), func(t *testing.T) {
      actual := add(case.a, case.b)
      expected := case.c
      if actual != expected {
        t.Errorf("add(%d, %d) -> %d != %d", case.a, case.b, actual, expected)
      }
    })
  }
}
```

Wired:
```
func TestAddition(t *testing.T) {
  addsCorrectly = func(a,b,c int) {
    t.Run(fmt.Sprintf("%d + %d = %d", case.a, case.b, case.c), func(t *testing.T) {
      actual := add(case.a, case.b)
      expected := case.c
      if actual != expected {
        t.Errorf("add(%d, %d) -> %d != %d", case.a, case.b, actual, expected)
      }
    })
  }

  addsCorrectly(1,2,3)
  addsCorrectly(2,4,6)
  addsCorrectly(38,88,111)
}
```

Benefits:
saves two lines and an indent for the `for...range`
names the test explicitly

(side note: totally notice the `test.Run` in the loop)

Even better when you're tempted to have your table drive conditional tests:
instead, name the test with a function name.
