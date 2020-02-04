---
layout: post
title: Nginx + Passenger on Gentoo
tags: ["technique", "ops"]
---
From the "niche interest" desk:

Nginx builds all of it's components into one executable (they argue that it's
necessary for their level of speed and security). Gentoo lets you configure
software all kinds of ways, so it's pretty easy to configure exactly which of
the myriad of modules you want to install.  But like every Linux distro,
they've had an ongoing tete-a-tete with Rubygems, so Passenger isn't supported
out of the box in the Gentoo set of options.  Passenger's idea of installing
itself  into Nginx is to recompile the whole thing
- *without* respecting the modules that were already installed.

It's a headache, and I've given up trying to assign blame - I think probably
everyone solved the (very large) problems in front of  them, and it happens
that their solutions don't interact well. (Gentoo Rubyists (and yes, I'm sure
the plural there is optimistic): I'm liking chruby + direnv + bundler as an
adjunct to eselect.)

But, there's a couple of hidden outs that make it entirely feasible to get a
respectable nginx/passenger deploy going on Gentoo, which I'll record here for
my own purposes, at least.


{% highlight bash %}
gem install passenger
mkdir /etc/portage/env
echo "NGINX_ADD_MODULES='$(passenger-config --nginx-addon-dir)'" > /etc/portage/env/nginx-passenger
echo "www-servers/nginx nginx-passenger" >> /etc/portage/package.env
emerge nginx
{% endhighlight %}

In /etc/nginx/nginx.conf, add:

{% highlight bash %}
passenger_root /usr/local/lib64/ruby/gems/2.0.0/gems/passenger-4.0.29/;
passenger_ruby /usr/bin/ruby20;
{% endhighlight %}
