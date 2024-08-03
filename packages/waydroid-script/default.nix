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

  version = "unstable-2024-01-20";

  src = fetchFromGitHub {
    owner = "casualsnek";
    repo = "waydroid_script";
    rev = "1a2d3ad643206ad5f040e0155bb7ab86c0430365";
    hash = "sha256-OiZO62cvsFyCUPGpWjhxVm8fZlulhccKylOCX/nEyJU=";
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
