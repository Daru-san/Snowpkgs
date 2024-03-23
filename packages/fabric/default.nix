{
  lib,
  python3Packages,
  fetchFromGitHub,
  gtk3,
  cairo,
  gtk-layer-shell,
  gobject-introspection,
  pip,
  psutil,
  pygobject3,
  pycairo,
  loguru,
  click,
  conf,
}:
with python3Packages;
  buildPythonApplication {
    pname = "fabric";
    version = "0.0.1";
    src = fetchFromGitHub {
      owner = "Fabric-Development";
      repo = "fabric";
      rev = "9adb28d7659d9068ff05f1410767334608fa4095";
      hash = "sha256-U9lA+nht23tXoSredZEnXOzW/lTH0rr29nQF5zP9eEo=";
    };
    propagatedBuildInputs = [
      gtk3
      cairo
      gtk-layer-shell
      gobject-introspection
      pip
      pygobject3
      pycairo
      loguru
      click
      psutil
      conf
    ];
    meta = with lib; {
      description = "Mixxc is a minimalistic and customizable volume mixer, created to seamlessly complement desktop widgets.";
      homepage = "https://github.com/Elvyria/mixxc";
      license = with licenses; [mit];
      maintainers = with maintainers; [darumaka];
      mainProgram = "mixxc";
      platforms = platforms.linux;
    };
  }
