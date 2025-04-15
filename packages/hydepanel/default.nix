{
  lib,
  python3,
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
  writeShellScript,
  makeWrapper,
}:
let
  start-script = writeShellScript "start.sh" '''';
in
python3.pkgs.buildPythonApplication rec {
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
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/hydepanel

    cp -r $src/{assets,modules,services,shared,styles,utils,widgets,main.py} $out/share/hydepanel

    patchShebangs $out/share/hydepanel/assets/scripts/*.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm775 ${start-script} $out/bin/hydepanel

    MAINPY=$out/hydepanel/share/main.py

    echo "python3 $MAINPY" >> $out/bin/hydepanel

    wrapProgram $out/bin/hydepanel \
      --prefix PATH : ${
        with lib;
        makeBinPath (flatten [
          dependencies
          python3
          buildInputs
        ])
      }

    runHook postInstall
  '';

  dependencies = with python3.pkgs; [
    click
    dbus-python
    fabric
    loguru
    psutil
    pycairo
    pygobject3
    setproctitle
  ];

  meta = {
    description = "Modular panel written on fabric";
    homepage = "https://github.com/rubiin/HyDePanel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "hydepanel";
  };
}
