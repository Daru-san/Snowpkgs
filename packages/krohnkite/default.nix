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
  version = "0.9.9.0-unstable-2025-04-02";

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = "krohnkite";
    rev = "472dcd66745f962236b0daf6b3eeeac8e5bc237c";
    hash = "sha256-CBC8x4qje6BtNakyVWz8bpWKJU94dl2guwqI58pV2NM=";
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
