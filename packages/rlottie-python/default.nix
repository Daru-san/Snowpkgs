{
  lib,
  python3,
  fetchFromGitHub,
  py-build-cmake
  }:
python3.pkgs.buildPythonApplication rec {
  pname = "rlottie-python";
  version = "1.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laggykiller";
    repo = "rlottie-python";
    rev = "v${version}";
    hash = "sha256-wSCBRTgE0g2b7fNdG8/Dj77EM1F/HYD/+iAchCqBb7g=";
    fetchSubmodules = true;
  };

  dontUseCmakeConfigure = true;

  build-system = [py-build-cmake];

   optional-dependencies = with python3.pkgs; {
    full = [
      pillow
    ];
    lint = [
      isort
      mypy
      ruff
      types-pillow
    ];
    test = [
      pytest
    ];
  };

  pythonImportsCheck = [
    "rlottie_python"
  ];

  meta = {
    description = "A ctypes API for rlottie, with additional functions for getting Pillow Image";
    homepage = "https://github.com/laggykiller/rlottie-python";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "rlottie-python";
  };
}
