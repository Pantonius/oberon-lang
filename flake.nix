{
  description = "Flake for oberon-lang";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        cppDependencies = [
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
        oberon-lang = pkgs.stdenv.mkDerivation {
          name = "oberon-lang";
          src = self;
          buildInputs = cppDependencies;
          buildPhase = "make -j $NIX_BUILD_CORES";

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            mv $TMP/source/build/olang/oberon-lang $out/bin
            mv $TMP/source/build/stdlib $out/bin
            runHook postInstall
          '';
        };
      in
      rec {
        defaultApp = flake-utils.lib.mkApp {
          drv = defaultPackage;
        };
        defaultPackage = oberon-lang;
        devShell = pkgs.mkShell {
          buildInputs = [
            oberon-lang
          ];
        };
      }
    );
}
