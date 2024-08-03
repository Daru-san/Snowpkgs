{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "poketex";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "poketex";
    rev = "v${version}";
    hash = "sha256-d/5uu70o7hrS4L3kZALBjd9Y1d/THPrlvwqKWEwGrxg=";
  };

  cargoHash = "sha256-0KUbnITIyKoQzc+pPqsan6rLraqnk+wHXYpNBzAXlvc=";

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
