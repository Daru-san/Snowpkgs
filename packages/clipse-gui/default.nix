{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "clipse-gui";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "d7omdev";
    repo = "clipse-gui";
    rev = "v${version}";
    hash = "sha256-7UnlGDPNycdTxpm/fXT6bFJU8U2UGqLgmspNukaFdWk=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    nuitka
    ordered-set
    pycairo
    pygobject
    zstandard
  ];

  pythonImportsCheck = [
    "clipse_gui"
  ];

  meta = {
    description = "A gui for the clipse clipboard";
    homepage = "https://github.com/d7omdev/clipse-gui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daru-san];
    mainProgram = "clipse-gui";
  };
}
