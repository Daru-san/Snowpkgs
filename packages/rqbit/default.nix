{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  darwin,
  cargo-tauri,
  buildNpmPackage,
  nodejs_20,
  glib,
  gtk3,
  libsoup,
  webkitgtk_4_0,
  gobject-introspection,
}:
let
  pname = "rqbit";

  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-Lt3HxK8fB1Xn2422wGkJ90muJjZ7r9ZHngGD/2tkaMM=";
  };

  node-frontend = buildNpmPackage {
    pname = "rqbit-frontend";

    nodejs = nodejs_20;

    inherit version src;

    sourceRoot = "${src.name}/crates/librqbit/webui";

    npmDepsHash = "sha256-VYPZXZx9rKLKZm5+d2wSVkoPLCQCffaeZVSi7mKRH/M=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/dist
      cp -r dist/** $out/dist

      runHook postInstall
    '';
  };

  desktop-src = stdenv.mkDerivation {
    inherit src;
    name = "rqbit";

    installPhase = ''
      mkdir -p $out

      cp -R $src/** $out/

      chmod -R a+rwx $out/*

      rm $out/crates/librqbit/build.rs

      mkdir -p $out/crates/librqbit/webui/dist
      cp -R ${node-frontend}/dist/** $out/crates/librqbit/webui/dist
    '';
  };

  rqbit-desktop = rustPlatform.buildRustPackage rec {
    pname = "rqbit-desktop";

    inherit version;

    src = desktop-src;

    cargoHash = "sha256-qeFrfXGfiznbGp4nxyeDxPz7zOheoSWyLZ0n0GKgiA8=";

    sourceRoot = "${src.name}/desktop/src-tauri";

    preConfigure = ''
      mkdir -p dist
      cp -R ${node-frontend}/dist/** dist
    '';

    postPatch = ''
      rm tauri.conf.json
      cp ${./tauri.conf.json} tauri.conf.json
    '';

    nativeBuildInputs = [
      cargo-tauri
    ] ++ lib.optionals stdenv.isLinux [ pkg-config ];

    buildPhase = ''
      runHook preBuild

      cargo tauri build -b deb

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share}

      cp target/release/bundle/deb/rqbit-desktop_${version}_amd64/data/usr/bin/rqbit-desktop $out/bin/rqbit-desktop
      cp -R target/release/bundle/deb/rqbit-desktop_${version}_amd64/data/usr/share/** $out/share/

      runHook postInstall
    '';

    buildInputs =
      [
        glib
        gtk3
        libsoup
        webkitgtk_4_0
        gobject-introspection
      ]
      ++ lib.optionals stdenv.isLinux [ openssl ]
      ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

    doCheck = false;
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-esDUzzVm5J8fKftBfk5StJzN1YzLa1p0t7BsoxzrowI=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  preConfigure = ''
    mkdir -p crates/librqbit/webui/dist
    cp -R ${node-frontend}/dist/** crates/librqbit/webui/dist
  '';

  postPatch = ''
    # This script fascilitates the build of the webui,
    #  and we are free to get rid of it now
    rm crates/librqbit/build.rs
  '';

  postInstall = ''
    cp ${rqbit-desktop}/bin/rqbit-desktop $out/bin/rqbit-desktop

    mkdir -p $out/share
    cp -R ${rqbit-desktop}/share/** $out/share/
  '';

  doCheck = false;

  meta = with lib; {
    description = "Bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    changelog = "https://github.com/ikatson/rqbit/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cafkafk
      toasteruwu
    ];
    mainProgram = "rqbit";
  };
}
