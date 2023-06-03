let
  unstableTgz = builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixos-nixos-20.03-2023-06-06";
    # Be sure to update the above if you update the archive
    url = https://github.com/nixos/nixpkgs/archive/1db42b7fe3878f3f5f7a4f2dc210772fd080e205.tar.gz;
    sha256 = "05k9y9ki6jhaqdhycnidnk5zrdzsdammbk5lsmsbz249hjhhgcgh";
  };
in
import unstableTgz {}
