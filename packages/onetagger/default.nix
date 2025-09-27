{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  libsoup_3,
  pango,
  webkitgtk_4_1,
  stdenv,
  darwin,
  alsa-lib,
  llvmPackages,
  glibc,
}:

rustPlatform.buildRustPackage rec {
  pname = "onetagger";
  version = "unstable-2025-08-06";

  src = fetchFromGitHub {
    owner = "Marekkon5";
    repo = "onetagger";
    rev = "2429a833cbafb9b057bc9e2268806e571a3ca1b5";
    hash = "sha256-EXkuBlOA/qBrgrckyufJ3HgxsaUycbYdfF9PanZ0O4g=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "songrec-0.2.1" = "sha256-pQKU99x52cYQjBVctsI4gdju9neB6R1bluL76O1MZMw=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook
    llvmPackages.clang
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    libsoup_3
    pango
    webkitgtk_4_1
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreAudio
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.Security
  ]
  ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ];

  meta = {
    description = "Music tagger for Windows, MacOS and Linux with Beatport, Discogs, Musicbrainz, Spotify, Traxsource and many other platforms support";
    homepage = "https://github.com/Marekkon5/onetagger?tab=readme-ov-file";
    changelog = "https://github.com/Marekkon5/onetagger/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "onetagger";
  };
}
