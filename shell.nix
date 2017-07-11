#{ pkgs ? import /home/judson/dev/nixpkgs {} }:
{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs) lib stdenv ruby bundler bundlerEnv;

  rubyEnv = bundlerEnv {
    name = "jekyll-blog";

    ruby = ruby; #ruby_1_9;

    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
  stdenv.mkDerivation {
    name = "blog-shell";
    src = ./.;

    buildInputs = [
      rubyEnv
      bundler
    ];
  }
