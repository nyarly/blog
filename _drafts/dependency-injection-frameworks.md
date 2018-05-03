---
layout: post
title: Dependency Injection Frameworks
---

They're a cancer. They're glitter.
Once they're in your project, you'll never get rid of them.
DI the pattern: good.
DI frameworks: bad.

Seems like it'll be good for testing.
But you spend more time setting up a DI provider than you would building a plain-old fixture.
Besides, you should be using doubles for tests - manually inject those into your one instance.

Interferes with reasoning.
All it's doing is sequencing function calls...

I suggest that you'll spend as much/more time debugging your DI framework code
than you would just writing the function calls.

"Good tooling integration"
Compiler errors are better - and you get those with function calls.

Service locator: you want to be able to find singletons.
Do that instead of a DI framework.
Maybe: define your SL structs and use them.
