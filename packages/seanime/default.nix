{
  stdenvNoCC,
  lib,
  buildGoModule,
  fetchFromGitHub,
  rustPlatform,
  buildNpmPackage,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  gtk3,
  openssl,
  webkitgtk_4_1,
  nix-update-script,
  google-fonts,
  gobject-introspection,
  libappindicator-gtk3,
  makeWrapper,
  withDesktop ? true,
}:
let
  pname = "seanime";
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    rev = "v${version}";
    hash = "sha256-W3M4n+NZJRHFieeeMAKMJz8fI5kWT3M6CiFhLLNSMDM=";
  };

  seanime-web = buildNpmPackage {
    pname = "seanime-web";

    inherit version src;

    npmDepsHash = "sha256-9qyHaOJQFO0jquKpXUusznfGCaeU3LCSPiCzTdKl20Y=";

    sourceRoot = "${src.name}/seanime-web";

    dontNpmBuild = true;

    patchPhase = ''
      runHook prePatch

      mkdir -p src/

      cp "${
        google-fonts.override { fonts = [ "Inter" ]; }
      }/share/fonts/truetype/Inter[opsz,wght].ttf" src/app/Inter.ttf

      substituteInPlace ./src/app/layout.tsx \
        --replace-quiet 'import { Inter } from "next/font/google"' 'import localFont from "next/font/local"' \
        --replace-quiet 'const inter = Inter({ subsets: ["latin"] })' 'const inter = localFont({ src: "./Inter.ttf" })'

      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild

      npm run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/web

      cp -r out/* $out/web

      runHook postInstall
    '';
  };

  seanime-server = buildGoModule {
    pname = "seanime-server";

    inherit src version;

    vendorHash = "sha256-He2ECCOTngnxibNS0llgMfa2J9/x6qEWrQ/VlB6x/tk=";

    preBuild = ''
      mkdir web

      cp -R ${seanime-web}/web/** web/

      #  .github scripts redeclare main
      rm -rf .github
    '';

    doCheck = false;

    ldflags = [
      "-s"
      "-w"
    ];
  };

  seanime-desktop = rustPlatform.buildRustPackage {
    pname = "seanime-desktop";

    inherit version src;

    sourceRoot = "${src.name}/seanime-desktop/src-tauri";

    cargoHash = "sha256-m9MjJxqfL9JdelV+V9zF4G5vKqbY97d+FHN+Di1GBMs=";

    nativeBuildInputs = [
      cargo-tauri
      pkg-config
      wrapGAppsHook3
    ];

    buildInputs = [
      gsettings-desktop-schemas
      gtk3
      openssl
      webkitgtk_4_1
      gobject-introspection
      libappindicator-gtk3
    ];

    postPatch = ''
      substituteInPlace ./tauri.conf.json \
        --replace-quiet '"frontendDist": "../../web-desktop",' '"frontendDist": "web-desktop",' \
    '';

    TEST_DATADIR = "";

    preBuild =
      let
        web-desktop = seanime-web.overrideAttrs {
          buildPhase = ''
            runHook preBuild

            npm run build:desktop

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/web

            cp -r out-desktop/* $out/web

            runHook postInstall
          '';
        };
      in
      ''
        mkdir web-desktop

        cp -R ${web-desktop}/web/* web-desktop

        cp ${seanime-server}/bin/seanime binaries/seanime-x86_64-unknown-linux-gnu
      '';

    doCheck = false;
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    ''
      mkdir -p $out/bin

      install -Dm775 ${seanime-server}/bin/seanime $out/bin/seanime
    ''
    + lib.optionals withDesktop ''
      cp -R ${seanime-desktop}/** $out/

      wrapProgram $out/bin/seanime-desktop \
        --prefix PATH : ${lib.makeBinPath seanime-desktop.buildInputs}
    '';

  passthru = {
    web = seanime-web;
    server = seanime-server;
    desktop = seanime-desktop;
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "web"
      "--subpackage"
      "server"
      "--subpackage"
      "desktop"
    ];
  };

  meta = {
    description = "Open-source media server with a web interface and desktop app for anime and manga";
    homepage = "https://github.com/5rahim/seanime";
    changelog = "https://github.com/5rahim/seanime/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ daru-san ];
    platforms = lib.platforms.linux;
    mainProgram = "seanime";
  };
}
