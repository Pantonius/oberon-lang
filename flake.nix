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
        let
          dependencies = [
            pkgs.libxml2
            pkgs.gcc
            pkgs.cmake
            pkgs.boost
            pkgs.llvmPackages_latest.llvm
            (pkgs.python3.withPackages (python-pkgs: [
              python-pkgs.lit
              python-pkgs.filecheck
              python-pkgs.sphinx
              python-pkgs.sphinx_rtd_theme
            ]))
          ];
        in
        {
          packages.default = pkgs.stdenv.mkDerivation {
            name = "oberon-lang";
            src = self;
            buildInputs = dependencies;
            buildPhase = "make -j $NIX_BUILD_CORES";

            installPhase = ''
              runHook preInstall

              mkdir -p $out/bin $out/lib
              mv $TMP/source/build/olang/oberon-lang $out/bin
              mv $TMP/source/build/stdlib/* $out/lib

              runHook postInstall
            '';

          };

          apps.default = {
            type = "app";
            program = "${self'.packages.default}/bin/oberon-lang";
          };

          devShells.default = pkgs.mkShell {
            buildInputs = dependencies;
          };
        };
    };
}
