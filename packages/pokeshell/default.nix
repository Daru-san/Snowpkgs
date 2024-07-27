{
  stdenv,
  lib,
  fetchFromGitHub,
  bash,
  jq,
  imagemagick,
  chafa,
  subversion,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "pokeshell";
  version = "1.0.0-unstable-2024-04-13";
  src = fetchFromGitHub {
    owner = "acxz";
    repo = "pokeshell";
    rev = "9d36fda54166918f7c7d7f01c1ca69d7b12bb53e";
    sha256 = "sha256-Wo7UltgkkuQp+jJuUm5p4VjVR0azdpPVtb4eLrl/jZw=";
  };
  buildInputs = [
    bash
    subversion
    jq
    chafa
    imagemagick
  ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -pv $out/bin

    cp -rv $src/bin/pokeshell $out/bin/pokeshell
    cp -rv $src/share $out

    wrapProgram $out/bin/pokeshell \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          subversion
          jq
          chafa
          imagemagick
        ]
      }
  '';
}
