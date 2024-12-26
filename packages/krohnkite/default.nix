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
  version = "0.9.8.4-unstable-2024-12-25";

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = "krohnkite";
    rev = "6881880ea97725f61d81bd1d2cc2694625ada9e4";
    hash = "sha256-9s2ZEp3FwVMm4A9sDx068ORal04vnc8ILINtS7WhhmM=";
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
