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
  version = "0.9.7-unstable-2024-08-08";

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = "krohnkite";
    rev = "e7f7851f8f56f52237db74cb91db126157eada19";
    hash = "sha256-zK9m0OYldrflwsjOaCBgyWPzFxPh0rFqvnd4R+9jxT8=";
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
