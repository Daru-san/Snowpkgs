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
  webkitgtk_4_0,
  nix-update-script,
  google-fonts,
  withDesktop ? true,
}:
let
  pname = "seanime";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    rev = "v${version}";
    hash = "sha256-aLKiUmT37pst2XoK+v84vcOtFT8VSdHrKlDekdKapJ4=";
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
        --replace-quiet 'const inter = Inter({ subsets: ["latin"] })' 'const inter = localFont({ src: "./Inter.ttf", subsets: ["latin"] })'

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
      cp -r out/** $out/web

      runHook postInstall
    '';
  };

  seanime-desktop = rustPlatform.buildRustPackage {
    pname = "seanime-desktop";

    inherit version src;

    sourceRoot = "${src.name}/seanime-desktop/src-tauri";

    cargoHash = "sha256-Hs+IYhZ3Aw8jPJbo9i2/wFQzViueBdOTkj5P996W5pU=";

    nativeBuildInputs = [
      cargo-tauri
      pkg-config
      wrapGAppsHook3
    ];

    buildInputs = [
      gsettings-desktop-schemas
      gtk3
      openssl
      webkitgtk_4_0
    ];

    preConfigure =
      let
        web-desktop = seanime-web.overrideAttrs ({
          buildPhase = ''
            runHook preBuild

            npm run build:desktop

            runHook postBuild
          '';
        });
      in
      ''
        mkdir web-desktop

        cp -R ${web-desktop}/out/** web-desktop/

        cp ${seanime-server}/bin/seanime binaries/seanime
      '';

    postPatch = ''
      substituteInPlace ./tauri.conf.json \
        --replace-quiet '"frontendDist": "../../web-desktop",' '"frontendDist": "web-desktop",' \
    '';
  };

  seanime-server = buildGoModule {
    pname = "seanime-server";

    inherit src version;

    vendorHash = "sha256-4liG/EB3KcOqUllTbcgFFGB0K473+7ZKfpQa/ODU+EI=";

    preConfigure = ''
      mkdir web

      cp -R ${seanime-web}/out/** web/
    '';

    ldflags = [
      "-s"
      "-w"
    ];
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  installPhase =
    ''
      install Dm775 ${seanime-server}/bin/seanime $out/bin/seanime
    ''
    + lib.optionals withDesktop ''
      cp -R ${seanime-desktop}/** out/
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
    mainProgram = "seanime";
  };
}
