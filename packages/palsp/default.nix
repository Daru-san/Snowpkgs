{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "palsp";
  version = "unstable-2025-03-18";

  src = fetchFromGitHub {
    owner = "tomas303";
    repo = "palsp";
    rev = "3e34d5d8ca17eb046422e868c70830534dd069bf";
    hash = "sha256-6+5iKKpUCbnZ7gdCNcSPFtx3s/EysLKxDAL6TmVZaLc=";
  };

  vendorHash = "sha256-rDBHDSUW82qwTwGplL1IE9VNBlGPpQ75l1IjsCbXr/Y=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "Lsp server for delphi / pascal";
    homepage = "https://github.com/tomas303/palsp";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ ];
    mainProgram = "palsp";
  };
}
