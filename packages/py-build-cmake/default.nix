{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "py-build-cmake";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tttapa";
    repo = "py-build-cmake";
    rev = version;
    hash = "sha256-8goGw9unCQFeSgTz7P4TidqUf/mJ9ZhnxjamlvIoaOk=";
  };

  build-system = [
    python3.pkgs.distlib
    python3.pkgs.lark
    python3.pkgs.packaging
    python3.pkgs.pyproject-metadata
    python3.pkgs.tomli
  ];

  dependencies = with python3.pkgs; [
    click
    distlib
    lark
    packaging
    pyproject-metadata
    tomli
    pyproject-metadata
  ];

  optional-dependencies = with python3.pkgs; {
    docs = [
      myst-parser
      sphinx
      sphinx-book-theme
      sphinx-design
    ];
    test = [
      jinja2
      nox
    ];
  };

  pythonImportsCheck = [
    "py_build_cmake"
  ];

  meta = {
    description = "Modern, PEP 517 compliant build backend for creating Python packages with extensions built using CMake";
    homepage = "https://github.com/tttapa/py-build-cmake";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daru-san];
    mainProgram = "py-build-cmake";
  };
}
