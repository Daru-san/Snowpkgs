{
  lib,
  pkgs,
  python3Packages,
  fetchFromGitHub,
  gtk3,
  cairo,
  gtk-layer-shell,
  gobject-introspection,
  pip ? pkgs.python3Packages.pip,
  psutil ? pkgs.python3Packages.psutil,
  pygobject3 ? pkgs.python3Packages.pygobject3,
  pycairo ? pkgs.python3Packages.pycairo,
  loguru ? pkgs.python3Packages.loguru,
  click ? pkgs.python3Packages.click,
  pkgconf,
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
    pyroject = true;
    doCheck = false;
    dependencies = [
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
      pkgconf
    ];
    meta = with lib; {
      description = "Fabric is a python widgets thing framework made for *Nix based systems (Wayland and X11), using GTK+.";
      homepage = "https://github.com/Fabric-Development/";
      maintainers = with maintainers; [darumaka];
      platforms = platforms.linux;
    };
  }
