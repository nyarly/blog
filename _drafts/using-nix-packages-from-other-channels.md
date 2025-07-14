---
layout: post
title: Using Nix Packages From Other Channels
---

Several approaches, each with tradeoffs

"freshness" dependencies stability

An overlay/override of src

pkgs.callPackage "${fetchTarball channel:nixos-18.09}/pkgs/shells/fish" {};

(import (fetchTarball { url = "https://github.com/NixOS/nixpkgs/tarball/<revision-you-want>"; sha256 = "..."; }) {}).fish

add something like nixpkgs1803 as a channel and then use `nixpkgs1803.fish` as the expression

just use flakes
