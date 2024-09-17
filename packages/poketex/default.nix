{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "poketex";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "poketex";
    rev = "v${version}";
    hash = "sha256-8f/eaNxhu5R6LQ1CisZ74+/o/sywFjZYl+v6bqeKJm8=";
  };

  cargoHash = "sha256-xYScwEsyyntF7/i/Anfayh3tQ9dPAKapfdcKwpYOrzo=";

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
