{
  pkgs,
}:

pkgs.stdenv.mkDerivation rec {
  pname = "oberon-lang";
  version = "0.2.0";

  src = ./.;

  buildInputs = (
    import ./dependencies.nix {
      inherit pkgs;
    }
  );

  buildPhase = ''
    cmake . -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release
    cmake --build . --parallel $NIX_BUILD_CORES
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/include
    mv olang/oberon-lang $out/bin
    mv stdlib/liboberon.so $out/lib
    mv stdlib/static/liboberon.a $out/lib
    mv stdlib/*.smb $out/include

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "An LLVM frontend for the Oberon programming language";
    homepage = "https://github.com/Pantonius/${pname}";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
