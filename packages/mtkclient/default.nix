{
  lib,
  python3,
  keystone,
  python3Packages,
  fetchFromGitHub,
  capstone,
}:
python3Packages.buildPythonPackage rec {
  pname = "mtkclient";
  version = "2.0.1.freeze";

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "mtkclient";
    rev = version;
    hash = "sha256-y2VCfjds1fN2G9MHYZveT3NQqYF7RO26gBykHY1O6o8=";
  };

  pyproject = true;

  buildInputs = [ keystone ];
  propagatedBuildInputs = with python3Packages; [
    capstone
    colorama
    flake8
    fusepy
    hatchling
    keystone-engine
    mock
    pycryptodome
    pycryptodomex
    pyserial
    pyside6
    pyusb
    setuptools
    shiboken6
    unicorn
  ];

  postFixup = ''
    cp -r *.py $out/lib/python${python3.pythonVersion}/site-packages/
    cp -r mtkclient $out/lib/python${python3.pythonVersion}/site-packages/
  '';

  pythonImportsCheck = [ "mtkclient" ];

  meta = {
    mainProgram = "mtk";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "MTK reverse engineering and flash tool";
    homepage = "https://github.com/bkerler/mtkclient";
    license = with lib.licenses; [ gpl3Only ];
  };
}
