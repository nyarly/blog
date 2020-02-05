---
layout: post
title: Holographic Testing
tags: [testing]
---
The idea is that you have a behavior that produces a complicated piece of data,
which you can spot check
(but more checks further couple the output,
making the tests more fragile).
But usually you have another behavior that consumes that data.
So: rather than extensively testing the intermediate product,
test that the producer and the consumer work correctly when wired together.

This is an integration test.
You should expect to add *regression* tests to the producer,
and to the consumer.
For example, additional spot checks of the producer's output,
or tests for the consumer's behavior when fed particular pieces of the data.

For the latter style of tests, it's often useful to have a "zero case":
an examplar of your input data that has a minimal behavior in the consumer,
and which you can update with test cases.
