{
  lib,
  python312Packages,
  fetchFromGitHub,
  networkmanager,
  pipewire,
  gnome-bluetooth_1_0,
  bluez,
  bluez-tools,
  dart-sass,
  brightnessctl,
  hypridle,
  hyprsunset,
  playerctl,
  makeWrapper,
  fabric,
  wrapGAppsHook,
  gtk3,
  gobject-introspection,
  rlottie-python,
}:
python312Packages.buildPythonApplication rec {
  pname = "hydepanel";
  version = "0.7.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "rubiin";
    repo = "HyDePanel";
    rev = "v${version}";
    hash = "sha256-eHp/tI7riJpiUlNxu684IqtHRFXDzFtgKr3aCCINQtQ=";
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    networkmanager
    pipewire
    gnome-bluetooth_1_0
    bluez
    bluez-tools
    dart-sass
    brightnessctl
    hypridle
    hyprsunset
    playerctl
    gtk3
  ] ++ fabric.buildInputs;

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin

    cp -r $src/{assets,modules,services,shared,styles,utils,widgets,main.py,config.json,hydepanel.schema.json} $out/bin/

    patchShebangs $out/bin/assets/scripts/*.sh

    sed -i '1i#!/usr/bin/env python3' $out/bin/main.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm775 $out/bin/main.py $out/bin/hydepanel

    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${
        with lib;
        makeBinPath (flatten [
          buildInputs
        ])
      }

    runHook postInstall
  '';

  dependencies =
    [
      rlottie-python
      (fabric.override {
        inherit python312Packages;
      })
    ]
    ++ (with python312Packages; [
      click
      dbus-python
      loguru
      psutil
      pycairo
      pygobject3
      setproctitle
      utils
      pyjson5
      pytomlpp
    ]);

  meta = {
    description = "Modular panel written on fabric";
    homepage = "https://github.com/rubiin/HyDePanel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "hydepanel";
  };
}
