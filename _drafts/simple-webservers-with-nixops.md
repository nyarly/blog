---
layout: post
title: A Simple Webservers with NixOps
---

After working with Nix and [NixOS](https://nixos.org/) casually for about a year
I started to play with NixOps, the deployment tooling built on top of Nix.
Right away, my reaction was
"gosh, that was easy!"
This is such a rare experience
with any software,
much less anything ops related,
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
I converted it over to NixOS,
and I've been so pleased
with that ongoing experience
that I thought I'd give NixOps
a try for moving my stuff
onto servers
that I run out of pocket.

## Local Work

I use [Jekyll](https://jekyllrb.com/) for this blog.
I probably sorely under-use it, actually.
Still, it's a very solid static site generator,
and Ruby remains well inside my comfort zone.

But rather than worry about
which version of Ruby I have installed,
and if libxml2 has slipped with respect to
mini_portile2,
I use `nix-shell` to set up my working environment.
Without going into too much detail,
it works something like `rvm` or `rbenv`
(or `virtualenv` or `nodenv` or ...)
in a language platform agnostic way.

Again, this is probably overkill for a blog,
but for my development projects it's been fantastic.
I especially enjoy that it works the same
regardless of working language or
required dependencies.
For instance,
I use `nix-shell` for Rust projects,
with a large Go project that
has dependencies on PostgreSQL and Java,
and for developing Ruby gems.
The only thing better than
using `nix-shell` myself
would be working on a team that
all used `nix-shell`.

The core model within Nix
is an "expression" that describes
how to build a piece of software.
It works just like
a package definition in
any other OS distribution system.
Expressions are written in
the Nix programming language though,
which makes them quite flexible.

One example of that flexibility is that
`nix-shell` can use the expression
for building and installing a software package,
and set up a shell environment with
all the build-time dependencies available.
The primary motivation being
to be able to work smoothly with packages
and you prepare them for distribution.

But it also works fantastically
for the original development of the project.
I've been treating this blog
as an ongoing software project,
and using an expression to describe
its build environment.
Until recently,
actually generating the site
and shipping it to the server
was entirely the job of
a simple Rakefile.

This blog's build expression lives
in a file called
(by Nix convention)
`default.nix`
and it looks like this:
```nix
{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs) lib stdenv ruby bundler bundlerEnv fetchFromGitHub;

  rubyEnv = bundlerEnv {
    inherit ruby;

    name = "jekyll-blog";

    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
  stdenv.mkDerivation {
    name = "blog-jdl";

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

    buildPhase = "jekyll build";
    installPhase = "cp -a _site $out";
  }
```



`Rakefile`:
```ruby
task :push do
  sh 'rsync -av _site/ lrd-admin:/var/www/clients/judsonlester.info/'
end

task :build do
  sh 'jekyll build'
end

task :update do
  puts ENV['NIXOPS_DIR']
  sh "nix-prefetch-git --no-deepClone git@github.com:nyarly/blog.git| jq '.sha256' > #{ENV['NIXOPS_DIR']}/blog/source.nix"

  %w[default.nix Gemfile Gemfile.lock gemset.nix].each do |file|
    cp file, Pathname.new(ENV['NIXOPS_DIR']).join("blog", file).expand_path
  end
end

task :default => [:build, :push]
```


`webserver.nix`:
```nix
let
  blog = import ./blog/default.nix {};
  acmeRoot = "/var/run/acme-challenges";
in
  {
    network.description = "Web server";

    webserver =
      {  pkgs, ... }:
      {
        services.httpd = {
          enable = true;
          adminAddr = "nyarly@gmail.com";
          virtualHosts = [
            {
              hostName = "judsonlester.info";
              serverAliases = [ "www.judsonlester.info" ];
              listen = [{ port = 80; }];
              extraConfig = ''
                Redirect / https://judsonlester.info
                Alias "/.well-known/acme-challenge" "${acmeRoot}/judsonlester.info/.well-known/acme-challenge"
                <Directory ${acmeRoot}/judsonlester.info>
                  Require all granted
                </Directory>
              '';

            }
            {
              hostName = "judsonlester.info";
              serverAliases = [ "www.judsonlester.info" ];
              listen = [{ port = 443; }];

              documentRoot = blog;
              enableSSL = true;
              sslServerCert = "/var/lib/acme/judsonlester.info/full.pem";
              sslServerKey = "/var/lib/acme/judsonlester.info/key.pem";

              extraConfig = ''
                Alias "/.well-known/acme-challenge" "${acmeRoot}/judsonlester.info/.well-known/acme-challenge"
                <Directory ${acmeRoot}/judsonlester.info>
                  Require all granted
                </Directory>
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
