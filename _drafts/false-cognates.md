---
layout: post
title: False Cognates
---
## This Is Like Inheritance, So...

This is a trap I've fallen into several times, and I'm not alone, by far.  I
feel like it's a bad idea to use an analogy between your problem space and the
language semantics your working in, and so proceed to map the problem using the
language itself.

As another contrived example, imagine you've got a program that will have items
that belong to categories.  The categories will get added to over time, and
categories will have subcategories in a strict tree.  The items will all belong
to a single category and have well defined, parameterized variation within a
category.

"Aha!" you say.  "Categories are a lot like classes, and items are like
instances of those classes.  I'm programming in (e.g.) Ruby, where I can knock
out a custom subclass any old time!"  We start out with something like

{% highlight ruby %}
class RootCategory
  attr_accessor :name, :size, :mood
  def self.sub_category(name)
    klass = Class.new(self)
    ::Kernel::const_set(name, klass)
  end
end

RootCategory.sub_category(:Awesome)
RootCategory.sub_category(:LessAwesome)
{% endhighlight %}

Yeah.  That's kind of what I'm talking about.  Best case, what's going to
happen is that the spec is going to change - item parameters change by category
(doable...) items can be in more than one category (modules?), categories can
have more than one parent (modules...?), categories can be deleted... That's
the best case.  Worst case is that I need to come along and integrate with your
code, and boy will that be a pain in the neck.

More controversially, imagine you have a piece of data that needs to be
processed in many little ways.  Like, say, an HTTP request.  We need to confirm
different headers, and load code and make DB connections available, until we
get to the real app that's going to really produce the response, and then we're
going to tweak that until it get's sent back to the browser.  And hey, doesn't
that remind you of a call stack?  So maybe we could have a series of little
one-method objects chained together so that they call each other and then
return the response of the next thing down?  Wouldn't that be a nice way to
decouple the various parts of processing HTTP?

Thanks a heap, PEP-333, and your descendant, everyone's pal: Rack.  They're
great, except if you want to do things in asymmetrical ways, or change the
processing chain.  Or understand what the hell is going on.  (Given that there
are multiple implementations of features that basic Rack provides, I think
there's some credence to "what does that do?")

So on the one hand, don't do that.  Implement categories as their own kind of
objects with normal references to each other instead of class-inheritance
links.  Build a processing pipeline, where the next thing in the stack is a
reference to an object rather than a proc embedded in the closure of another
proc.

On the other hand, there's a point where if you take that advice to it's
logical conclusion, you ignore language idiom completely, or try to re-code
other languages in the current one, and now you're fighting against language
semantics.  You could argue that EventMachine is an example of this, or
Celluloid.  You could also argue that the "compiles into..." boom recently is a
sort of example of this, too - Coffeescript, Elixir, Clojure and all their
friends.

Maybe the swing is "it's all Turing-complete, so why bother with idiom?"  which
I find a little depressing.

## Does It Go In This, or Just Around Here?

This one is pretty much exclusive to Javascript and Lua (at least, that I know
and use.)  You could, I suppose, torture Ruby into a place where it'd matter,
but why?

You need access to a piece of data in a function.  You can get it there three
ways: as arguments to the function, as a variable in scope of the function, or
as a field on the host object (or it's prototype chain.)

(Lua fans: sub in fun times with metatables for Javascript's more proscriptive
inheritance.  I'm not sure it changes the problem much.)

Given that we want to avoid using globals where we can, putting a variable in
scope of a function means defining the function in a closure where that
variable is bound.

There's lots of proposals for doing class-like inheritance in Javascript, and a
lot of them come down to making "private" variables in a closure and setting up
accessors etc in there.  (My basic feeling is that Javascript doesn't do class
based inheritence...)

But there are times when it's reasonable to use closure-bound variable in
Javascript - especially when you have a method factory.  But then, wouldn't it
make more sense to use a prototype, build a constructor function, and tie the
variables into the function you're trying to build that way?  That calls for
some illustration:

{% highlight javascript %}
function factory_function(name) {
  return function(){
    return name
  }
}

//versus

function BasicNamed() {
  this.name = ""
}

BasicNamed.prototype.getName = function(){
  return this.name
}

factory_chain(name) {
  var chained = function(){}
  chained.prototype = new BasicNamed() //or this could be made a singleton...
    var named = new chained()
    named.name = name
    return named // or perfect parallel is named.getName
}
{% endhighlight %}

So, the later is more verbose, but you do expose the "name" field, which means
you can manipulate it later. In a more complicated example, you can examine,
filter and debug the "named" object a lot more easily than you can the result
of calling factory_function(name).

I guess this last issue is basically "the interview question I hope never to
have to answer" because I vacillate on which technique I prefer, and really
don't have a solid handle on which to go with in a particular case.

Refactoring back and forth is also a real pain (which is like, 60% of my
irritations in Javascript), so deciding on one really is a commitment.

One thing it does underscore: Lua and JavaScript are weak on clear idiom, but
benefit strongly from harsh discipline in coding, so it kind of echoes back to
the previous section.
