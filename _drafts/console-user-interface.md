---
layout: post
title: Console User Interface
---

Assume that users will copy and paste important strings.
As such,
don't put characters into those strings
that aren't cogent.
For instance,
when reporting the existence of a new file,
don't surround the path
with quotation marks or include a trailing period.
For best results,
delimit such token strings with
whitespace, ideally newlines,
in order to set them out and make copying easy.

This task is complicated
by variations between terminal emulators -
for instancce,
OS X's default Terminal considers hyphens ("-") to be a word delimiter
(and therefore double-clicks will select one side or the other),
while other terminals do not
(so double clicks will include the hyphen and characters on either side.)

Be careful when coloring text.
Many applications assume
that the user is using
a light-on-dark terminal coloring scheme,
which may or may not be true.
Using relative terminal escapes for background
while using absolute ones
for foreground can lead to illegible output.
This is especially regretable
when the highlighting is being used
in order to draw attention to important notices.

Provide whatever help you can to tab-completion tools.
Shell applications should include
either support scripts or a completion command
to provide hints to the shell -
even bash can provide good tab completion with the right prompting.
If you write your own console,
strongly consider using at least readline
to provide completion and history,
as the interface with readline
is one which many users are already familiar with.
Not providing at least history editing
and tab completion in a modern interactive tool is unacceptable.

Often a terminal based application
*doesn't* need its own interactive interface.
There's a very narrow case
for multiple, transient operations
that require a relatively short-lived state.
A lot of the time, though
that short-lived state can just go in a file,
and you can operate on that.
The advantage, again
is a consistent interface for the user.
