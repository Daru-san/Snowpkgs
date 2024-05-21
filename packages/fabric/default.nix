{
  lib,
  python3Packages,
  fetchFromGitHub,
  gtk3,
  cairo,
  gtk-layer-shell,
  gobject-introspection,
  pkgconf,
}:
python3Packages.buildPythonApplication {
  pname = "fabric";
  version = "0-unstable-2024-05-15";
  src = fetchFromGitHub {
    owner = "Fabric-Development";
    repo = "fabric";
    rev = "67978f7526f620a7cbbe989643b4d2da6f87ee92";
    hash = "sha256-4sLlnR1gFzeDjrxvx76dwcSaM3Q5phL6LgwUP2VLCic=";
  };
  pyroject = true;
  doCheck = false;
  dependencies =
    [
      gtk3
      cairo
      gtk-layer-shell
      gobject-introspection
      pkgconf
    ]
    ++ (with python3Packages; [
      pip
      psutil
      pygobject3
      pycairo
      loguru
      click
    ]);
  meta = with lib; {
    description = "Fabric is a python widgets thing framework made for *Nix based systems (Wayland and X11), using GTK+.";
    homepage = "https://github.com/Fabric-Development/";
    maintainers = with maintainers; [daru-san];
    platforms = platforms.linux;
  };
}
