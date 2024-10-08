{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook4,
  autoPatchelfHook,
  webkitgtk,
}:
stdenv.mkDerivation rec {
  pname = "bridge-editor";
  version = "2.7.37";

  src = fetchurl {
    url = "https://github.com/bridge-core/editor/releases/download/v${version}/bridge_${version}_amd64.deb";
    hash = "sha256-p0ln5Q64KFQucQWKD9Lou/G2dmxEougL7OIE6Ny3hRw=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook4
    autoPatchelfHook
  ];

  buildInputs = [ webkitgtk ];
  unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/usr/* $out
    rm -rf $out/usr
  '';

  meta = with lib; {
    description = "A lightweight IDE for Minecraft Add-Ons";
    homepage = "https://github.com/bridge-core/editor";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "bridge";
  };
}
