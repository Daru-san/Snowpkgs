{
  lib,
  wrapGAppsHook3,
  buildNpmPackage,
  fetchFromGitHub,
  rustPlatform,
  nodejs_20,
  cargo-tauri_1,
  pkg-config,
  gsettings-desktop-schemas,
  webkitgtk_4_0,
  gtk3,
  openssl,
}:
let
  pname = "editor";
  version = "2.7.44";

  src = fetchFromGitHub {
    owner = "bridge-core";
    repo = "editor";
    rev = "v${version}";
    hash = "sha256-oiZpuH12Xw/EMBTxiqvezjFasbmKelWT+KN7bL67m7Q=";
  };

  frontend = buildNpmPackage {
    pname = "editor-frontend";

    inherit version src;

    nodejs = nodejs_20;

    dontNpmBuild = true;

    npmDepsHash = "sha256-0nAI+SCsG763DhlJykzurC0xroEelZMN0lgcyWeTA9E=";

    makeCacheWritable = true;

    env.VITE_IS_TAURI_APP = true;

    npmFlags = [
      "--legacy-peer-deps"
    ];

    postPatch = ''
      rm package-lock.json
      ln -s ${./package-lock.json} package-lock.json
    '';

    buildPhase = ''
      runHook preBuild

      node ./scripts/buildApp.mjs

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/dist
      cp -r dist/** $out/dist

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-ZtXUmEoMVoHhdbkCjtNmAPDYR4FHjTXz6ZIRj+QUDq0=";

  nativeBuildInputs = [
    wrapGAppsHook3
    cargo-tauri_1
    pkg-config
  ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
    openssl
    webkitgtk_4_0
  ];

  preConfigure = ''
    mkdir -p dist
    cp -R ${frontend}/dist/** dist
  '';

  postPatch = ''
    substituteInPlace ./tauri.conf.json \
      --replace-quiet '"distDir": "../dist",' '"distDir": "dist",' \
      --replace-quiet '"beforeBuildCommand": "VITE_IS_TAURI_APP=true npm run build",' '"beforeBuildCommand": "",'
  '';

  buildPhase = ''
    runHook preBuild

    cargo tauri build -b deb

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    mkdir -p $out/share/

    cp target/release/bundle/deb/bridge_${version}_amd64/data/usr/bin/bridge $out/bin/bridge
    cp -R target/release/bundle/deb/bridge_${version}_amd64/data/usr/share/** $out/share/

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/bridge" \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  meta = with lib; {
    description = "A lightweight IDE for Minecraft Add-Ons";
    homepage = "https://github.com/bridge-core/editor";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "bridge";
  };
}
