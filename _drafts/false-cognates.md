---
layout: post
title: False Cognates
---

This is a set of posts, I think. Link 'em together etc.

This is a trap I've fallen into several times, and I'm not alone, by far.  It's
a bad idea to use an analogy between your problem space and the language
semantics your working in, and so proceed to map the problem using the language
itself.

## This Is Like Inheritance, So...

Imagine you've got a program that has items
that belong to categories.  The categories get added to over time, and
categories will have subcategories in a strict tree.  The items all belong
to a single category and have well defined, parameterized variation within a
category.

"Aha!" you say.  "Categories are a lot like classes, and items are like
instances of those classes.  I'll write this in Ruby, where I can knock
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

The problem is that the relationship between the problem space (items in
categories) and the language semantics (instances of classes) is accidental.
It's very convenient in the present moment, but where we need to be able to
adapt to a changing problem domain, language semantics are relatively fixed.

Best case, what's going to happen is that the spec is going to change. What if
items can be in more than one category, categories can have more than one
parent, or categories can be deleted... There's ways in which you might be able
to support those changes in Ruby, but it'd get increasingly difficult.

Even worse, imagine that I wrote the above treatment of items-in-categories and
you need to use the library in your application - and then you discover that
you need to be able to delete categories. It's bad enough doing the backflips
when you've got complete control over the code. There's no way to extend that
kind of semantics-mapping smoothly.

## Pipelines as Call Stacks

As a further example, imagine you have a piece of data that needs to be
processed in many little ways.   For instance, an HTTP request.  We need to
confirm different headers, and load code and make DB connections available,
until we get to the real app that's going to really produce the response, and
then we're going to manipulate the response until it gets sent back to the
browser.

And hey, doesn't that remind you of a call stack?  So maybe we could
have a series of little one-method objects chained together so that they call
each other and then return the response of the next thing down?  Wouldn't that
be a nice way to decouple the various parts of processing HTTP?

That's the reasoning behind PEP-333, and its descendant Rack. It's a really
powerful, easy to compose system, and Ruby web applications have been built on
that basic premise for a long time now.

The composible middleware pattern has drawbacks, as a consequence of being tied
the the semantic form of method composition. You can't perform processing
in asymmetrical ways, or change the processing chain on the fly.  Even allowing
for up front manipulation of the chain starts introducing a lot of complexity
into the otherwise simple composition.

It can also be difficult to understand how the request gets processed in long
pipelines, or what a particular middleware is doing because of how it interacts
with with the composition chain. `Rack::Static` is a pretty good example of
this, or `Rack::Mapping`, both of which dispatch requests to different child
stacks depending on their characteristics.

So on the one hand, don't do that.  Implement categories as their own kind of
objects with normal references to each other instead of class-inheritance
links.  Build a processing pipeline, where the next thing in the stack is a
reference to an object rather than a proc embedded in the closure of another
proc.

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
