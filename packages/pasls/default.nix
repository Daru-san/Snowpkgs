{
  lib,
  stdenv,
  fetchFromGitHub,
  lazarus,
  fpc,
}:

stdenv.mkDerivation rec {
  pname = "pascal-language-server";

  version = "unstable-2024-11-08";

  src = fetchFromGitHub {
    owner = "castle-engine";
    repo = "pascal-language-server";
    rev = "d6987689c78e0e054359b904d844cdf46ffed071";
    hash = "sha256-u/atSCi6em3nxVDUY4gCZoRPybCVXcQDUajfsfyoTzA=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/server";

  buildInputs = [
    lazarus
    fpc
  ];

  buildPhase = ''
    runHook preBuild

    lazbuild pasls.lpi

    runHook postBuild
  '';

  meta = {
    description = "LSP server implementation for Pascal (easy to use with Castle Game Engine";
    homepage = "https://github.com/castle-engine/pascal-language-server";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pascal-language-server";
    platforms = lib.platforms.all;
  };
}
