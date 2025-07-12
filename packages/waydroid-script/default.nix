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

  version = "0-unstable-2025-07-11";

  src = fetchFromGitHub {
    owner = "casualsnek";
    repo = "waydroid_script";
    rev = "5527d390ebf313f10c2600635708d21846620ac3";
    hash = "sha256-6CXe+vAbxD02Nwn8nidXj5VhSsh49sulxNljwoUhCzI=";
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
