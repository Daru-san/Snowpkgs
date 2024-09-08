{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  scrcpy,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenv.mkDerivation rec {
  pname = "qt-scrcpy";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "barry-ran";
    repo = "QtScrcpy";
    rev = "v${version}";
    hash = "sha256-PL/UvRNqvLaFuvSHbkJsaJ2nqRp5+ERM+rmlKVtbShk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    copyDesktopItems
  ];

  buildInputs = with libsForQt5; [
    qtbase
    wrapQtAppsHook
    qtmultimedia
    scrcpy
    qtx11extras
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=sign-compare"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r ../output/x64/Release/* $out/bin
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "QtScrcpy";
      exec = "QtScrcpy %U";
      icon = "qtscrcpy";
      desktopName = "QtScrcpy";
      genericName = "Android Display Control";
      categories = [
        "Utility"
        "RemoteAccess"
      ];
    })
  ];

  meta = with lib; {
    description = "Android real-time display control software";
    homepage = "https://github.com/barry-ran/QtScrcpy";
    license = licenses.asl20;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "QtScrcpy";
    platforms = platforms.all;
  };
}
