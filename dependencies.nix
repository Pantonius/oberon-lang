{ pkgs }:
with pkgs;
[
  libxml2
  gcc
  cmake
  boost
  llvmPackages_latest.llvm
  (python3.withPackages (python-pkgs: [
    python-pkgs.lit
    python-pkgs.filecheck
    python-pkgs.sphinx
    python-pkgs.sphinx_rtd_theme
  ]))
]
