{
  lib,
  python3,
  fetchFromGitHub,
  wrapGAppsHook,
  gtk3,
  gobject-introspection,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "clipse-gui";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "d7omdev";
    repo = "clipse-gui";
    rev = "v${version}";
    hash = "sha256-bh5QlmQUJ0qGVOGsWW0j3zvnYvAR9flfYXsG+6d0fso=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    nuitka
    ordered-set
    pycairo
    pygobject3
    zstandard
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];
  buildInputs = [
    gtk3
  ];

  pythonImportsCheck = [
    "clipse_gui"
  ];

  postInstall = ''
    mkdir -p $out/bin

    install -Dm775 $src/clipse-gui.py $out/bin/clipse-gui
  '';

  meta = {
    description = "A gui for the clipse clipboard";
    homepage = "https://github.com/d7omdev/clipse-gui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "clipse-gui";
  };
}
