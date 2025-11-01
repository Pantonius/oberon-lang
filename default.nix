{
  pkgs,
  name ? "oberon-lang",
}:

pkgs.stdenv.mkDerivation rec {
  pname = name;
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

    mkdir -p $out/bin $out/lib
    ls $TMP
    ls $TMP/${pname}
    mv $TMP/${pname}/build/olang/oberon-lang $out/bin
    mv $TMP/${pname}/build/stdlib/* $out/lib

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "An LLVM frontend for the Oberon programming language";
    homepage = "https://github.com/Pantonius/${pname}";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
