---
layout: post
title: Nix, a universal language packager
---

(originally sent as an email to nix-devel@)

A lot of my direct interaction with nixpkgs has been related to nix-shell and
setting up development environments. My initial discovery of Nix was related to
one of the surges of interest in a package manager for Erlang.

One interesting feature of this is that the best way to accomplish this is to
use Nix's versions of packages where ever possible as opposed to using
platform-specific package management. For instance, better to use the Ruby
bundleEnv/bundix tooling than to use Bundler directly.

What I notice is that each of the efforts to adapt a platform repository into
Nix appears to take up the problem afresh. Certainly, there are details of each
platform that necessitate particular approaches, but it seems like there are
best practices surrounding the general problem that could be captured and
shared. Potentially there could even be generic Nix tooling built around the
problem.

For example, each platform has some means by which it determines the
dependencies of an application. Bundler's Gemfile.lock is the one I'm
personally most familiar with, and bundix seems well on its way to providing
complete mirrors of Gemfile.lock into a nix set. I was fascinated to see that
the Nix/Rust approach involved building a parser for TOML (and Cargo.toml) in
Nix. It seems to me there's a legitimately open question of whether it makes
sense to reimplement the platform tooling in Nix or to execute those tools and
translate their output into Nix code.

There's also the contrast between Ruby and Python in this case: there's a
carefully maintained list of python libraries in Nix, which it's apparently the
preferred approach to use as buildInputs - even though there's a convenience
tool in the vein of Bundix to produce self contained expressions. Because Ruby
applications in Nix each have their own set of gems; they aren't shared except
inasmuch as the same gem (to the version) should produce the same derivation.
I'm also unclear about which approach is preferred *in general.*

I'm keenly interested in this problem space. I'm candidly of the opinion that
having a package manager per platform is an discipline-scoped antipattern, and
that if we could all agree to use a single manager (Nix, obviously) we could
start sharing best practices. A prerequisite to that utopian future, though, is
its converse: that a single package manager figure out how to serve all*
platforms. There's certainly challenges (npm/node is it's own special
entertaining problem space), but as time goes on, my optimism grows.

What I'm hoping is to hear opinion about those best practices. Is the
per-application Ruby model preferable? Or the Python per-repo model? Should we
consume the output of the existing tools, or parallel them? What other
questions arise out of generalizing the problem, and can we address them
meaningfully?
