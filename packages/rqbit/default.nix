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
  glib,
  gtk3,
  libsoup_2_4,
  webkitgtk_4_0,
  gobject-introspection,
}:
let
  pname = "rqbit";

  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    tag = "v${version}";
    hash = "sha256-5Z75YlKBELWhkPc9wUX/0VXbvmyEbBosrO4CEeHy4UY=";
  };

  webui = buildNpmPackage {
    pname = "rqbit-webui";

    inherit version src;

    sourceRoot = "${src.name}/crates/librqbit/webui";

    npmDepsHash = "sha256-vib8jpf7Jn1qv0m/dWJ4TbisByczNbtEd8hIM5ll2Q8=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/dist
      cp -r dist/** $out/dist

      runHook postInstall
    '';
  };

  rqbit-desktop =
    let
      desktop-frontend = buildNpmPackage {
        pname = "rqbit-desktop";

        inherit version src;

        sourceRoot = "${src.name}/desktop";

        npmDepsHash = "sha256-7qnhdKL5qykb4q5J+ciCjo2VZkYl0n03Txi2aQRUxYY=";

        npmPackFlags = [ "--ignore-scripts" ];

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
          cp -R ${desktop-frontend}}/dist/** $out/crates/librqbit/webui/dist
        '';
      };

    in
    rustPlatform.buildRustPackage rec {
      pname = "rqbit-desktop";

      inherit version;

      src = desktop-src;

      cargoHash = "sha256-qeFrfXGfiznbGp4nxyeDxPz7zOheoSWyLZ0n0GKgiA8=";

      sourceRoot = "${src.name}/desktop/src-tauri";

      preConfigure = ''
        mkdir -p dist
        cp -R ${desktop-frontend}/dist/** dist
      '';

      postPatch = ''
        substituteInPlace ./tauri.conf.json \
          --replace-fail '"distDir": "../dist",' '"distDir": "dist",' \
          --replace-fail '"beforeBuildCommand": "npm run build",' '"beforeBuildCommand": "",'
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

      buildInputs = [
        glib
        gtk3
        libsoup_2_4
        webkitgtk_4_0
        gobject-introspection
      ] ++ lib.optionals stdenv.isLinux [ openssl ];

      doCheck = false;
    };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-cJRv+b780daYeiAFnbhYoYNwOy9GL8x9Ve6XxG95QpU=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ];

  preConfigure = ''
    mkdir -p crates/librqbit/webui/dist
    cp -R ${webui}/dist/** crates/librqbit/webui/dist
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
