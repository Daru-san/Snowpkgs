{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "xbyak-aarch64";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "fujitsu";
    repo = "xbyak_aarch64";
    rev = "v${version}";
    hash = "sha256-30oEMADPaqr1OWGYVLa9SwcyBI6pcISnk+AdsgLLX24=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "";
    homepage = "https://github.com/fujitsu/xbyak_aarch64/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daru-san ];
    platforms = lib.platforms.all;
  };
}
