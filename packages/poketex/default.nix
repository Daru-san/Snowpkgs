{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "poketex";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "poketex";
    rev = "v${version}";
    hash = "sha256-cT5PBGtpx4lTAgt32rUNpaoVErPL2rVO7q3SnmGpyuE=";
  };

  cargoHash = "sha256-jip7PJ0JelZp+15fJfYU80lxGgBu6Y/afacznr/Zs9o=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.CoreFoundation ];

  postInstall = ''
    mkdir -p $out/local/share/poketex
    cp -rf $src/colorscripts $out/local/share/poketex
  '';

  meta = with lib; {
    description = "Simple Pokedex based on TUI(Terminal User Interface";
    homepage = "https://github.com/ckaznable/poketex";
    license = licenses.mit;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "poketex";
  };
}
