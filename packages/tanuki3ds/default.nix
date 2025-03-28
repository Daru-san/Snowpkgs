{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
  sdl3,
  xxHash,
  cglm,
  fdk_aac,
  capstone,
  xbyak,
  xbyak-aarch64,
}:

stdenv.mkDerivation rec {
  pname = "tanuki3-ds";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "burhanr13";
    repo = "Tanuki3DS";
    rev = "v${version}";
    hash = "sha256-+Y33OmP4Cq7MeP33fCHdYOKN7aKq5LFrhv0VZXeh2wg=";
  };

  nativeBuildInputs = [ clang ];

  buildInputs = [
    sdl3
    cglm
    xxHash
    fdk_aac
    capstone
    xbyak
  ];

  meta = {
    description = "3DS Emulator";
    homepage = "https://github.com/burhanr13/Tanuki3DS";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "tanuki3-ds";
    platforms = lib.platforms.all;
  };
}
