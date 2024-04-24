{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
  mpv,
}:
stdenv.mkDerivation rec {
  pname = "mangayomi";
  version = "0.2.2";

  src = fetchzip {
    url = "https://github.com/kodjodevf/mangayomi/releases/download/v${version}/Mangayomi-v${version}-linux.zip";
    hash = "sha256-4CkijAlenhht8tyk3nBULaBPE0GBf6DVII699/RmmWI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    mpv
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D mangayomi $out/bin/mangayomi
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://studio-link.com";
    description = "Voip transfer";
    platforms = platforms.linux;
  };
}
