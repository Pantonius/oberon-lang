{
  description = "Flake for oberon-lang";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { self', pkgs, ... }:
        {
          packages.default = pkgs.callPackage ./default.nix {
            inherit pkgs;
          };

          apps.default = {
            type = "app";
            program = "${self'.packages.default}/bin/oberon-lang";
          };

          devShells.default = pkgs.mkShell {
            buildInputs = import ./dependencies.nix { inherit pkgs; };
          };
        };
    };
}
