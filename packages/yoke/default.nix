{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "yoke";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rmst";
    repo = "yoke";
    rev = "v${version}";
    hash = "sha256-/pP6vdeFzAMbrF1tI0IcIYy4dLrvDWrtonbBxUE/2z8=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    zeroconf
    python-uinput
  ];

  pythonImportsCheck = [ "yoke" ];

  meta = with lib; {
    description = "Turns your Android device into a customizable gamepad for Windows/Mac/Linux";
    homepage = "https://github.com/rmst/yoke";
    license = licenses.mit;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "yoke";
  };
}
