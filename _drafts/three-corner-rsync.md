---
layout: post
title: Three Corner Rsync
---

This is such a good trick, I wanted to share.

Here's the situation: you have a ton of files on Old Server, and you want to
get them to New Server. Both of them have nice fat pipes - they may even be on
the save 10G ethernet switch.

You could do something like:

{% highlight bash %}
rsync -av old-server:/files/ /tmp/old-server/
rsync -av /tmp/old-server/ new-server:/files
{% endhighlight %}

But now you're pulling those files down to your local machine
(which <em>probably</em> has the spare disk space) over your office pipe, which
is maybe 10% the pipe your servers might share. Plus you're then pulling it
over the office wi-fi, and that's down to 1% of the bandwidth. Plus everyone in
your office is going to look around at the ops guy who's choking the pipe
again.

Or you could go onto one of the servers and set up an SSH account for the other
server and shuffle keys around and all that. But that's a big hassle, and you
have to remember to get rid of the unnecessary account afterwards. Which if
you're me, you'll forget to do.

But you already have an account on both machines with you public key in an
authorized_keys file somewhere. In that case, start out with this:

{% highlight bash %}
ssh -O exit old-server
ssh -O check old-server
{% endhighlight %}

You want something like: `"Control socket ... No such file or
directory"` Otherwise, it means that you have an existing connection to
old-server. Usually you have an existing SSH session open, and you can just
close it. If you're feeling lazy and irresponsible, the message we don't want
says something like `"Master running (pid=12345)"` - you can just
kill the master SSH process and end the connection that way...

Now, we make sure that we have the keys for the new-server in our agent:

{% highlight bash %}
ssh-add ~/.ssh/new_server_rsa
ssh-add ~/.ssh/old_server_rsa
{% endhighlight %}

With the preliminaries out of the way, the real juice looks like this:

{% highlight bash %}
ssh -A old-server 'rsync -av /files/ new-server:/files/'
{% endhighlight bash %}

And now you've got a full-pipe transfer going from the old server to the new
one, using the credentials stored in your local agent to authenticate you first
from your console to the old-server, and then from the old-server to the new
one. You'll get the usual rsync update output as the transfer goes, and at the
end everything will be transferred over.

Frankly, I think there ought to be a merit badge or something. It's that cool
