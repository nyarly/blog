---
layout: post
title: Simple webservers with NixOps
---

OMG SO COOL

`shell.nix`:
```nix
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
```

`blog/default.nix`:
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
    name = "jdl-blog";

    src = fetchFromGitHub {
      owner = "nyarly";
      repo = "blog";
      rev = "master";
      sha256 = import ./source.nix;
    };

    buildInputs = [
      rubyEnv
      bundler
    ];

    buildPhase = "jekyll build";
    installPhase = "cp -a _site $out";
  }
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
