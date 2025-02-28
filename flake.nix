{
  description = "nyarly's personal blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }: (flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};

    rubyEnv = pkgs.bundlerEnv {
      inherit (pkgs) ruby;

      name = "jekyll-blog";

      gemfile = ./Gemfile;
      lockfile = ./Gemfile.lock;
      gemset = ./gemset.nix;
    };
  in
    {
    packages.blog = pkgs.stdenv.mkDerivation {
      name = "blog-jdl";

      src = if builtins.pathExists(./source.json) then
        builtins.fetchGit (
          let
            source = builtins.fromJSON (builtins.readFile ./source.json);
          in
            {
            url = "git@github.com:nyarly/blog.git";
            inherit (source) rev;
          }
        )
      else
        pkgs.nix-gitignore.gitignoreSource ["_drafts/"] ./.;

      buildInputs = with pkgs; [
        libmysqlclient
        mysql
        bundler
        bundix
        nix-prefetch-git
        rubyEnv
      ];

      buildPhase = "jekyll build";
      installPhase = "cp -a _site $out";
    };

    packages.default = self.packages.${system}.blog;

    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        libmysqlclient
        mysql
        bundler
        bundix
        nix-prefetch-git
        rubyEnv
      ];
    };
  }
  ));
}
