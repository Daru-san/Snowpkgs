{
  lib,
  stdenv,
  fetchFromGitHub,
  fpc,
  lazarus,
  pkgs,
}:
stdenv.mkDerivation {
  pname = "pascal-language-server";
  version = "unstable-2024-01-06";

  src = fetchFromGitHub {
    owner = "Isopod";
    repo = "pascal-language-server";
    rev = "0d7ae1795d420c81d9049385ba47cb5f787ddf37";
    hash = "sha256-o1nqBAF3ULpJzwKDxjuC284ZIHRfz8oTFSZYw0JN/oY=";
    fetchSubmodules = true;
  };

  buildInputs = [
    lazarus
    fpc
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)

    export BUILD=$(mktemp -d)

    mkdir -p $BUILD/lib/${pkgs.system}/

    cp -r $src/server/* $BUILD/

    lazbuild $BUILD/pasls.lpi --lazarusdir=${lazarus}/share/lazarus

    mkdir -p $out/bin

    cp -r $BUILD/lib/${pkgs.system}/* $out/bin/

    runHook postBuild
  '';

  meta = {
    description = "LSP server implementation for Pascal";
    homepage = "https://github.com/Isopod/pascal-language-server";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "pasls";
    platforms = lib.platforms.all;
  };
}
