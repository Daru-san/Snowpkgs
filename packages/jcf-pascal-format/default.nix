{
  lib,
  stdenv,
  fetchFromGitHub,
  fpc,
  lazarus,
}:

stdenv.mkDerivation rec {
  pname = "jcf-pascal-format";
  version = "1.0.2-4d3a7bf";

  src = fetchFromGitHub {
    owner = "quadroid";
    repo = "jcf-pascal-format";
    rev = "v${version}";
    hash = "sha256-vXnN2Ke0TxRX5GL8W7sB1c7MLW/iePyo94GFnIb3vsI=";
  };

  buildInputs = [
    lazarus
    fpc
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)

    lazbuild App/pascal_format.lpi --lazarusdir=${lazarus}/share/lazarus

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    install -Dm775 /build/source/pascal-format $out/bin/pascal-format

    runHook postInstall
  '';
  meta = {
    description = "JEDI code formatter better compatible with modern Delphi";
    homepage = "https://github.com/quadroid/jcf-pascal-format/releases/tag/v1.0.2-4d3a7bf";
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "jcf-pascal-format";
    platforms = lib.platforms.all;
  };
}
