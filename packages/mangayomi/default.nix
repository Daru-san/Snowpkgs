{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  mpv,
  unzip,
  gtk3,
  pango,
  cairo,
  flutter,
  wrapGAppsHook4,
  jre_minimal,
}:
stdenv.mkDerivation rec {
  pname = "mangayomi";
  version = "0.2.7";

  src = fetchurl {
    url = "https://github.com/kodjodevf/mangayomi/releases/download/v${version}/Mangayomi-v${version}-linux.zip";
    hash = "sha256-z+KS7YF5Op4OxiGswpB6P6ysDgWDYKbAGoB6YMTnUbQ=";
  };
  dontUnpack = true;
  nativeBuildInputs = [
    autoPatchelfHook
    unzip
    wrapGAppsHook4
  ];

  builtInputs = [
    gtk3
    jre_minimal
    pango
    cairo
    flutter
  ];
  runtimeDependencies = [ mpv ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out
    unzip $src
    cp -avr lib $out/lib
    install -m755 -D mangayomi $out/bin/mangayomi
  '';

  meta = with lib; {
    description = "Manga reader and anime streamer";
    homepage = "https://github.com/kodjodevf/mangayomi";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "mangayomi";
  };
}
