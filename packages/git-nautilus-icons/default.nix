{
  lib,
  fetchFromGitHub,
  gnome,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "git-nautilus-icons";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisjbillington";
    repo = "git-nautilus-icons";
    rev = version;
    hash = "sha256-8AcAyWphzNwn0s2YUEDGSwpNlgl5i3+KDTwjEdeSvEw=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
  ];

  buildInputs = [
    gnome.nautilus
    gnome.nautilus-python
  ];

  meta = with lib; {
    description = "Nautilus Python extension to overlay icons on files in git repositories ";
    license = licenses.bsd2;
    maintainers = with maintainers; [ daru-san ];
    homepage = "https://github.com/chrisjbillington/git-nautilus-icons";
    platforms = platforms.linux;
  };
}
