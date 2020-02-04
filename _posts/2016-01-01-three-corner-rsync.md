---
layout: post
title: Three Corner Rsync
tags: ["technique", "ops"]
---

This is such a good trick, I wanted to share.

Here's the situation: you have a ton of files on Old Server, and you want to
get them to New Server. Both of them have nice fat pipes - they may even be on
the same 10G ethernet switch.

You could do something like:

{% highlight shell %}
> rsync -av old-server:/files/ /tmp/old-server/
> rsync -av /tmp/old-server/ new-server:/files
{% endhighlight %}

The trouble with this is that it's sending files over the public internet,
using up your local network connection, and it's sending the files over that
slower network _twice._ Excuses to grab a cup of coffee aside, there has to be
a bette way.

Or you could go onto one of the servers and set up an SSH account for the other
server and shuffle keys around and all that. But that's a big hassle, and you
have to remember to get rid of the unnecessary account afterwards. Which if
you're me, you'll forget to do.

But _you_ already have an account on both machines with you public key in an
authorized_keys file somewhere.

Now, we make sure that we have the keys for the new-server in our agent:

{% highlight shell %}
> ssh-add ~/.ssh/new_server_rsa
> ssh-add ~/.ssh/old_server_rsa
{% endhighlight %}

With the preliminaries out of the way, the real juice looks like this:

{% highlight shell %}
> ssh -A old-server 'rsync -av /files/ new-server:/files/'
{% endhighlight bash %}

And now you've got a full-pipe transfer going from the old server to the new
one, using the credentials stored in your local agent to authenticate you first
from your console to the old-server, and then from the old-server to the new
one. You'll get the usual rsync update output as the transfer goes, and at the
end everything will be transferred over.

Frankly, I think there ought to be a merit badge or something. It's that cool

## Control Sockets

If you've set up master sockets for your servers (which is very handy), the
above might not work. The reason is that SSH set's up agent forwarding (which
is what the `-A` in the above does) when it opens the connection to a server.
If you're using master sockets, that connection has already been established,
and SSH will (silently) ignore the request to forward your agent connection.

In that case, start out with this:

{% highlight shell %}
> ssh -O exit old-server
> ssh -O check old-server
{% endhighlight %}

You want something like: `"Control socket ... No such file or
directory"` Otherwise, it means that you have an existing connection to
old-server. Usually you have an existing SSH session open, and you can just
close it. If you're feeling lazy and irresponsible, the message we don't want
says something like `"Master running (pid=12345)"` - you can just
kill the master SSH process and end the connection that way...

## A Proviso

The one problem with this technique is that it relies on something called
'agent forwarding,' which can have security implications. If you're worried
about that, setting up the temporary account between servers is probably your
best bet.
