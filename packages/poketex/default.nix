{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "poketex";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "poketex";
    rev = "v${version}";
    hash = "sha256-nd0HheUhkHcYsOhLjPrUslTMPdgHkKe5yOrYuJQANJc=";
  };

  cargoHash = "sha256-auWjFVfDy27luUVsQfwENtNGO6bFAzep0tl3WpCkW9I=";

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
