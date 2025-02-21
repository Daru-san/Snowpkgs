{
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

  web-desktop = buildNpmPackage {
    pname = "seanime-web";
    inherit version src;
    npmDepsHash = lib.fakeHash;
    sourceRoot = "${src.name}/seanime-web";
  };

  desktop-app = rustPlatform.buildRustPackage {
    pname = "seanime-desktop";
    inherit version src;
    sourceRoot = "${src.name}/seanime-desktop/src-tauri";

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

    preConfigure = ''
      mkdir web-desktop
      cp -R ${web-desktop}/dist/** web-desktop

      cp ${go-mod}/bin/seanime binaries/seanime
    '';

    postPatch = ''
      substituteInPlace ./tauri.conf.json \
        --replace-quiet '"frontendDist": "../../web-desktop",' '"frontendDist": "web-desktop",' \
    '';
  };

  go-mod = buildGoModule {
    inherit pname src version;

    vendorHash = "sha256-4liG/EB3KcOqUllTbcgFFGB0K473+7ZKfpQa/ODU+EI=";

    ldflags = [
      "-s"
      "-w"
    ];
  };
in

{
  inherit pname version;

  installPhase =
    ''
      install Dm775 ${go-mod}/bin/seanime $out/bin/seanime
    ''
    + lib.optional withDesktop ''
      cp -R ${desktop-app}/** out/
    '';

  meta = {
    description = "Open-source media server with a web interface and desktop app for anime and manga";
    homepage = "https://github.com/5rahim/seanime";
    changelog = "https://github.com/5rahim/seanime/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "seanime";
  };
}
