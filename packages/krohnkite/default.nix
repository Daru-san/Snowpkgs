{
  lib,
  fetchFromGitHub,
  stdenv,
  libsForQt5,
}:
let
  inherit (lib) maintainers licenses;
in
stdenv.mkDerivation rec {
  pname = "krohnkite";
  version = "0.9.8.2-unstable-2024-10-08";

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = "krohnkite";
    rev = "56df0da265aa248a4fa7a0133a7b208bdc4f3dbd";
    hash = "sha256-zd2PV3rNiwZRpo2B2PfH/wxjBezS/3vHDlJU3w9+7f0=";
  };

  buildInputs = with libsForQt5; [
    kcoreaddons
    kwindowsystem
    plasma-framework
    systemsettings
    wrapQtAppsHook
  ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    plasmapkg2 --type kwinscript --install ${src}/res/ --packageroot $out/share/kwin/scripts
    install -Dm644 ${src}/res/metadata.desktop $out/share/kservices5/krohnkite.desktop

    runHook postInstall
  '';

  meta = {
    description = "Dynamic tiling extension for KWin";
    license = licenses.mit;
    maintainers = with maintainers; [ daru-san ];
    inherit (src.meta) homepage;
    inherit (libsForQt5.kwindowsystem.meta) platforms;
  };
}
