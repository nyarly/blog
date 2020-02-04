---
layout: post
title: Simple Webservers with NixOps
tags: ["technique", "ops"]
---

After working with Nix and NixOS casually for about a year
I started to play with NixOps, the deployment tooling built on top of Nix.
Right away, my reaction was
"gosh, that was easy!"

This is such a rare experience
with any software,
much less anything operations related,
it was surprising.
The process was so straightforward
and rapid
that I wanted to share the details.
Hopefully this'll serve as
a quick introduction to the Nix ecosystem,
and to NixOps in particular.

## What Had Happened Was...

For much of the last decade,
I was a co-owner of
a full service web consultancy.
Operations tasks were
primarily my responsibility.
A little bit over two years ago,
the consultancy folded
(which is a story for another time).
I'm finally getting around
to the process of rejiggering
legacy servers there,
mostly to reduce operating costs.

One of the services hosted there
was this blog.
For a variety of reasons,
I wanted to migrate my personal web presence
onto servers I'm directly responsible for.

The last time I refreshed my working machine,
I converted it over to [NixOS](https://nixos.org/),
and I've been so pleased
with that ongoing experience
that I thought I'd give NixOps
a try for moving my stuff
onto servers
that I run out of pocket.

## Local Work

I use [Jekyll](https://jekyllrb.com/) for this blog;
I probably sorely under-use it.
It's a very solid and powerful static site generator,
and Ruby remains well inside my comfort zone.

But rather than worry about
which version of Ruby I have installed,
(and if libxml2 has slipped with respect to mini_portile2...)
I use `nix-shell` to set up my working environment.
Without going into too much detail,
it works something like `rvm`
(or `rbenv` or `virtualenv` or `nodenv` or ...)
in a language-platform agnostic way.

Again, this is probably overkill for a blog,
but for my development projects it's been fantastic.
I especially enjoy that
I can use the same tool
irrespective of
language or required dependencies.
For instance,
I use `nix-shell`
with a large Go project that
has dependencies on PostgreSQL and Java.
I use it with
Rust and
to develop Ruby gems.
The only thing better than
using `nix-shell` myself
would be working on a team that
all used `nix-shell`.

The core model within Nix
is an "expression" that describes
how to build a piece of software.
It works much like
a package definition in
any other OS distribution system.
Expressions are written in
the Nix programming language,
which makes them very flexible.

One example of that flexibility is that
`nix-shell` can take the expression
writen for building a software package
and set up a shell environment with
all of its build-time dependencies available.
The primary motivation
for this workflow is
to work smoothly with packages
as you prepare them for distribution.

But it also works tremendously well
for the original development of the project.
I've been treating this blog
as an ongoing software project,
and using an expression to describe
its "build" environment.
That meant picking a version of Ruby,
installing Jekyll and Rake
and plugins
and all of their dependencies,
and keeping those installs isolated
from other Ruby work I do
on the same system.

This blog's build expression lives
in a file called
(by Nix convention)
`default.nix`
and it looks like this:
```nix
{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs) lib stdenv ruby bundler bundlerEnv fetchFromGitHub;

  # This sets up the Ruby environment, complete with Bundler's Gemfile
  # Many of these settings have defaults, but I tend towards the explicit.
  rubyEnv = bundlerEnv {
    inherit ruby;

    name = "jekyll-blog";

    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    # This file is specially generated to adapt Rubygems to the Nixpkgs distribution
    gemset = ./gemset.nix;
  };
in
  stdenv.mkDerivation {
    name = "blog-jdl";

    # This conditional means that I work with the local source for authoring,
    # but pin a particular git revision for publication.
    src = if builtins.pathExists(./source.nix) then
      fetchFromGitHub {
        owner = "nyarly";
        repo = "blog";
        rev = "master";
        sha256 = import ./source.nix;
        }
    else
      ./.;

    buildInputs = [
      rubyEnv
      bundler
    ];

    # These are the steps to actually build and publish the blog.
    # nix-shell ignores them - I just run `jekyll serve` to author.
    buildPhase = "jekyll build";
    installPhase = "cp -a _site $out";
  }
```

This is the whole
`Rakefile`
for this blog.
I could probably get away with
a single "publish.rb"
(or a shell script.)

```ruby
task :update do
  # This command captures the remote git revision into a file for deployment.
  # Note that this is the file that triggers the src conditional in default.nix.
  sh "nix-prefetch-git --no-deepClone git@github.com:nyarly/blog.git| jq '.sha256' > #{ENV['NIXOPS_DIR']}/blog/source.nix"

  # Then we keep the build description files in sync with the deployment configuration.
  %w[default.nix Gemfile Gemfile.lock gemset.nix].each do |file|
    cp file, Pathname.new(ENV['NIXOPS_DIR']).join("blog", file).expand_path
  end
end
```

## From My Desk to Your Screen

Most of the above
is serves as a kind of prologue.
I'd already built it up
as I got more confident with using
Nix with Ruby and Jekyll.
There some adaptation to make it work with deployment,
but interestingly,
none of those adaptations
are _commitments._
I could go back to rsyncing to Nginx
(or converting the whole thing to S3)
without having to undo my changes.

What was really cool
was that I got from nothing
(literally, an empty console on AWS)
to a running server
in 3 20-minute sessions.
The hardest thing
(as ever)
was deciding whether to use
`mod_rewrite` or `mod_redirect`
in Apache.

In NixOS, all the packaging is
handled by Nixpkgs,
which is the Nix based package distribution.
Configuration is abstracted into
a flavor of expression called a "module",
and modules are composed into
a single system-wide configuration.
The consequence is that you wind up
writing an expression to build
a computer installation
in the same way that you describe
the build and installation of
a piece of software.
In a manner of speaking,
you build a computer the same way
that you build a piece of software.

NixOps is the
deployment and orchestration tooling
built on top of NixOS.
You arrange computer configurations
into networks,
and pair them with descriptions of
how to provision hardware for them.

This is how
a simple Apache webserver
configured to work with [LetsEncrypt](https://letsencrypt.org/) looks:

```nix
let
  # This pulls in the default.nix for the blog,
  # as copied into the deployment repo by the Rakefile.
  blog = import ./blog/default.nix {};
  acmeRoot = "/var/run/acme-challenges";
in
  {
    network.description = "Web server";

    webserver =
      { ... }:
      # This is the server configuration as it would be provided to NixOS if
      # I were deploying by hand.
      {
        services.httpd = {
          enable = true;
          adminAddr = "nyarly@gmail.com";
          extraConfig = ''
            <Directory ${acmeRoot}/judsonlester.info>
              Require all granted
            </Directory>
          '';
          virtualHosts = [
            {
              hostName = "judsonlester.info";
              serverAliases = [ "www.judsonlester.info" ];
              listen = [{ port = 80; }];
              extraConfig = ''
                Redirect / https://judsonlester.info
                Alias "/.well-known/acme-challenge" "${acmeRoot}/judsonlester.info/.well-known/acme-challenge"
              '';

            }
            {
              hostName = "judsonlester.info";
              serverAliases = [ "www.judsonlester.info" ];
              listen = [{ port = 443; }];

              # This is where the blog itself gets actually served.
              documentRoot = blog;
              enableSSL = true;
              sslServerCert = "/var/lib/acme/judsonlester.info/full.pem";
              sslServerKey = "/var/lib/acme/judsonlester.info/key.pem";

              extraConfig = ''
                Alias "/.well-known/acme-challenge" "${acmeRoot}/judsonlester.info/.well-known/acme-challenge"
              '';
            }
          ];
        };

        security.acme.certs = {
          "judsonlester.info" = {
            webroot = acmeRoot + "/judsonlester.info";
            email = "nyarly@gmail.com";
          };
        };

        networking.firewall.allowedTCPPorts = [ 22 80 443 ];
      };
  }
```

If you're not familiar with setting up Apache,
don't worry too much.
It's mostly pretty tedious,
and you can basically fiddle around
with the documentation until it does what you want.
With `nix-shell` it's easy to
set up an Apache server
and experiment locally
until you have configs that are working!

If you are familiar with this process,
I hope you'll agree that `webserver.nix`
describes just what's unique about this server.
The rigmarole of installing packages
and maintaining configurations
is all reduced to
what amounts to
expressing how what you want
varies from a stock install.
Having specified
`services.httpd.enable = true`
(i.e. "install and turn up Apache"),
much of the configuration
addresses how I want that to vary
from a basic Apache installation.

There's also an `ec2.nix` that describes
the AWS EC2 instances I wanted to deploy to,
the security groups to apply,
IP addresses,
and all that stuff.

To associated the expression files
with the deployment
I needed to issue the command (once)
```bash
> nixops create ./webserver.nix ./ec2.nix -d webserver
```

That and the actual deploy command
are the only two command line examples in this article.
That fact just now struck me as
unique and interesting:
most tutorials about
setting up servers involve a lot of
"copy and paste this into your shell."

(I'm fibbing a little:
I did need to
record AWS credentials
for NixOps to use.)

Conversely, Nix supports and encourages
a descriptive approach.
You don't make a series of
state dependent changes to the state of a server.
You describe what you want that server to look like
and tell Nix "make it like that."

That philosophy is hardly new -
Chef and Puppet both popularized
a decade ago.
Before that, CFEngine and tools like it
strove to make it possible.
Nix unifies the whole approach,
however,
establishing descriptive builds of everything
from individual software packages,
up through full network deployments.

And the other command,
to examine the state of the servers
as I've amended it
(in this case, by adding a new post)
and realize my intent
on actual servers
so you can see it
looks like this:
```bash
> nixops deploy -d webserver # "make it like that"
```
