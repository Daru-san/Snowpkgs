{
  makeWrapper,
  nix-update,
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "snow-updater";
  version = "1.1";
  format = "other";

  src = ./.;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ nix-update ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm775 $src/update.py $out/bin/${pname}
  '';

  postInstall =
    let
      wrapperPath = lib.makeBinPath [ nix-update ];
    in
    ''
      wrapProgram $out/bin/snow-updater \
        --prefix PATH : ${wrapperPath}
    '';

  meta = {
    description = "The update script for my packages";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daru-san ];
  };
}
