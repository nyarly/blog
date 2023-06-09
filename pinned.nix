let
  unstableTgz = builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixos-nixos-23.05-2023-06-06";
    # Be sure to update the above if you update the archive
    url = https://github.com/nixos/nixpkgs/archive/81ed90058a851eb73be835c770e062c6938c8a9e.tar.gz;
    sha256 = "130fxl6i6mlspgmyyd1l0f1smvgp0xr1d8mbjnmcz68wk7wl21kw";
  };
in
import unstableTgz {}
