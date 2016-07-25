---
layout: post
title: Transitional Conversation
---

Reading https://speakerdeck.com/searls/the-social-coding-contract?slide=374
Conversations have natural media
Conversations change over time
Different media are good for different things
Visibility/privacy
Immediacy/permanence

Chat => blog post
Tweet => hangout
"Help me out?" {chat, forum, f2f} => docs
Code => docs

Println <-> Debugger
Debugger -> tests
Println -> instrumentation

Repeated flows:
If we chat about something in terms of support,
and that turns into a forum post,
and that becomes part of official docs,
there's people who won't RTFM
and there's new questions in IRC
and that leads to new forum posts...

So how can we shortcut that?
Some of this is an SEO problem:
The worst thing about LMGTFY
is when you Alread Googled That For Yourself
and Google didn't help.

There's likewise a whole analogy between asking a good question
and writing a good test.
You need to setup, exercise, assert and (rarely) teardown
You have to
establish the context of your question
(e.g. who you are, the kind of thing you're doing)
then explain what you've tried to do
describe what happened, as compared to what you wanted to happen,
and then ask what you need to do,
or not do,
or do differently.

Support question -> bug report

Tools possible?
Tools would be multi-purpose.
A tool that can capture the circumstance to ask a good support question
also captures the scenario for a regression test if you've found a bug.
