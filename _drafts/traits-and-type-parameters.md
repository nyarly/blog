---
layout: post
title: Traits and type parameters
---

A Rust interview question that occurred to me (and that would catch me flat-footed): You're designing a new trait. Would you put a type parameter on the trait itself vs. on its method(s) vs. use an associated type? Why? Discuss trade-offs of each choice. Consider TryFrom.
4
1
16
￼
Lucio Franco
@lucio_d_franco
·
2h
Associated types when I need "some" generic type. Generic on the trait for when a method on that trait is generic over a single type in its parameters. And I rarely use generics on fn since that is not object safe but it can be useful if you have a specific situation for them.
2
3
￼
Mat Fournier
@mat4nier
Replying to
@lucio_d_franco
 and
@judsonlester
What do you mean not object safe ?
11:42 AM · Jan 30, 2020·Twitter for Android
1
 Like
￼
Lucio Franco
@lucio_d_franco
·
1h
Replying to
@mat4nier
 and
@judsonlester
Basically, if you have a fn on a trait that does this `bar<T>(t: T)` then it is no longer object safe, aka you can't turn it into a trait object. This is because the generic is not known at compile time and thus there is no way to know that type at compile time.
1
￼
Lucio Franco
@lucio_d_franco
·
1h
Here is an example that will not compile:

https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=651c2ed2ca6dfdf67a84d46e07d3ef6c

Tony “Abolish ICE” Arcieri ￼
@bascule
·
1h
Replying to
@judsonlester
 and
@zmanian
Generic type parameters on traits are useful if you want to impl the trait repeatedly for different types. They’re also the easiest path to object safety (e.g. generic method params aren’t object safe)


￼
Lucio Franco
@lucio_d_franco
·
2h
The cost of AT vs Generic on the trait really depends but generally also comes down to how you use the trait. AT can "hide" some specific type within the trait which is _not_ generic to that trait implementation.

Generics are more ergonomically costly than AT but are more flexy.
1
1
￼
Lucio Franco
@lucio_d_franco
·
2h
So conclusion is: Use AT until you really need things to be generic over per trait impl, then use generics on the trait. If those don't fit use generic on a trait fn.
