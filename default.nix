{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs) lib stdenv ruby bundler bundlerEnv;

  rubyEnv = bundlerEnv {
    inherit ruby;

    name = "jekyll-blog";

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
