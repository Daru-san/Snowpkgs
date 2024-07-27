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
  version = "0-unstable-2024-06-18";
  src = fetchFromGitHub {
    owner = "Fabric-Development";
    repo = "fabric";
    rev = "17a99336dabb6b8ea4b40ee294c89e488b81533c";
    hash = "sha256-oYlKIUQjXbLuRREmOHBD/6yD2qlMEAV53viauOvM35s=";
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
    description = "Python widgets framework made for *Nix based systems (Wayland and X11), using GTK+.";
    homepage = "https://github.com/Fabric-Development";
    maintainers = with maintainers; [ daru-san ];
    platforms = platforms.linux;
  };
}
