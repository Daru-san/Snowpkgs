{
  stdenv,
  makeWrapper,
  nix-update,
  lib,
}:
stdenv.mkDerivation {
  pname = "snow-update";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm775 update.sh $out/bin/snow-update
  '';

  postInstall = let
    wrapperPath = lib.makeBinPath [nix-update];
  in ''
    wrapProgram $out/bin/snow-update \
      --prefix PATH : ${wrapperPath}
  '';

  meta = {
    description = "The update script";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [daru-san];
  };
}
