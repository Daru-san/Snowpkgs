{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  cmake,
  json-glib,
  polkit,
  gtk3,
  pkg-config,
  wrapGAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "cmd-polkit";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "OmarCastro";
    repo = "cmd-polkit";
    rev = "v${version}";
    hash = "sha256-oQaGV/ROP9YFyL8owduKOZLjqyx9D35xH67gNKECduQ=";
  };

  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    ninja
    wrapGAppsHook
  ];

  buildInputs = [
    json-glib
    glib
    polkit
    gtk3
  ];

  meta = with lib; {
    description = "Easily create polkit authentication agents by using commands";
    homepage = "https://github.com/OmarCastro/cmd-polkit";
    changelog = "https://github.com/OmarCastro/cmd-polkit/blob/${src.rev}/CHANGELOG";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "cmd-polkit";
    platforms = platforms.all;
  };
}
