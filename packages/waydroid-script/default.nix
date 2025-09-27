{
  python3,
  fetchFromGitHub,
  lib,
  lzip,
  stdenvNoCC,
}:
let
  wrappedPath = lib.makeBinPath [
    lzip
    python3
  ];
in
stdenvNoCC.mkDerivation rec {
  name = "waydroid_script";

  version = "0-unstable-2025-08-31";

  src = fetchFromGitHub {
    owner = "casualsnek";
    repo = "waydroid_script";
    rev = "fcb15624db0811615ea9800837a836c4777674bf";
    hash = "sha256-Epvl6thT6mJqurZV1FV6Zdd6Kn13ZAC/BUaywVLpOIc=";
  };

  buildInputs = [
    (python3.withPackages (
      ps: with ps; [
        tqdm
        requests
        inquirerpy
      ]
    ))
  ];

  postPatch = ''
    patchShebangs main.py
  '';

  installPhase = ''
    mkdir -p $out/libexec
    cp -r . $out/libexec/waydroid_script
    mkdir -p $out/bin
    ln -s $out/libexec/waydroid_script/main.py $out/bin/waydroid_script
  '';

  postInstall = ''
    wrapProgram $out/bin/waydroid_script \
      --prefix PATH : "${wrappedPath}"
  '';

  meta.mainProgram = "waydroid_script";
}
