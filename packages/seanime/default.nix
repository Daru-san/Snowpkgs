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
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  libayatana-appindicator,
  withDesktop ? false,
}:
let
  pname = "seanime";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    rev = "v${version}";
    hash = "sha256-c17cmZscoGONr4zQ4z0Pdpb2GA2gBG4O6L6QvvJQXcA=";
  };

  seanime-web = buildNpmPackage {
    pname = "seanime-web";

    inherit version src;

    npmDepsHash = "sha256-wwRQpr+czJ225RReGLy/EqLa9Hqn6VlLDmI78U09HiE=";

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

    vendorHash = "sha256-gBwe+7/AxU8K0BtbdCLeNvbMDgW5XmVztqrowWPj1dw=";

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

    cargoHash = "sha256-rUSugriXI0NIjwSEAeekxcdMv/3qqNuBcEPhp1hpgCU=";

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
      libayatana-appindicator
    ];

    postPatch = ''
      substituteInPlace ./tauri.conf.json \
        --replace-fail '"frontendDist": "../../web-desktop",' '"frontendDist": "web-desktop",' \

      substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
        --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
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

  desktopEntry = makeDesktopItem {
    name = "seanime";
    type = "Application";
    desktopName = "Seanime Desktop";
    genericName = "Media server";
    comment = "Open-source media server with a web interface";
    icon = "seanime";
    categories = [
      "Video"
      "AudioVideo"
    ];
    exec = "seanime-desktop %U";
    terminal = false;
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase =
    ''
      runHook preInstall

      mkdir -p $out/bin

      install -Dm775 ${seanime-server}/bin/seanime $out/bin/seanime
    ''
    + lib.optionalString withDesktop ''
      install -Dm644 ${./icon.svg} $out/share/icons/hicolor/scalable/apps/seanime.svg

      cp -R ${seanime-desktop}/** $out/

      wrapProgram $out/bin/seanime-desktop \
        --prefix PATH : ${lib.makeBinPath seanime-desktop.buildInputs}

      runHook postInstall
    '';

  desktopItems = lib.optionals withDesktop [ desktopEntry ];

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
