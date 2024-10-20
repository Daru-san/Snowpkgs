{
  lib,
  wrapGAppsHook4,
  autoPatchelfHook,
  buildNpmPackage,
  fetchFromGitHub,
  rustPlatform,
  nodejs_20,
}:
buildNpmPackage rec {
  pname = "editor";
  version = "2.7.37";

  src = fetchFromGitHub {
    owner = "bridge-core";
    repo = "editor";
    rev = "v${version}";
    hash = "sha256-fW/MIr9Idb5AJFpKFTcbl0XInhxNQDVY1qoGIwRxzp0=";
  };

  nodejs = nodejs_20;

  packageLock = ./package-lock.json;

  npmDepsHash = "sha256-0nAI+SCsG763DhlJykzurC0xroEelZMN0lgcyWeTA9E=";

  makeCacheWritable = true;

  npmFlags = [
    "--legacy-peer-deps"
  ];

  postPatch = ''
    rm package-lock.json
    ln -s ${./package-lock.json} package-lock.json
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    sourceRoot = "${src.name}/${cargoRoot}";
    hash = "sha256-Q8Ny4rkW+1g1825vsfOU3UHHXoxRo6wezwcHz9puTwI=";
  };

  cargoRoot = "src-tauri";

  nativeBuildInputs = [
    wrapGAppsHook4
    autoPatchelfHook
  ];

  meta = with lib; {
    description = "A lightweight IDE for Minecraft Add-Ons";
    homepage = "https://github.com/bridge-core/editor";
    platforms = lib.platforms.all;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "bridge";
  };
}
