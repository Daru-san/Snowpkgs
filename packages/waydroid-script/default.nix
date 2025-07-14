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

  version = "0-unstable-2025-07-13";

  src = fetchFromGitHub {
    owner = "casualsnek";
    repo = "waydroid_script";
    rev = "3e344b360f64f4a417c4f5e9a3b1aae3da9fdfb9";
    hash = "sha256-l4L11Ilz3Y2lmKceg0+ZROPADgqhOwxzR/8V+ffyTjY=";
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
