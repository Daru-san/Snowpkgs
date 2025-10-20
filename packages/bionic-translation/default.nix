{
  lib,
  stdenv,
  fetchFromGitLab,
  mesa,
  wayland,
  libglvnd,
  libbsd,
  libunwind,
  libelf,
  meson,
  ninja,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bionic-translation";
  version = "0-unstable-2025-10-08";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "bionic_translation";
    rev = "028fb270a852f4791b522389d8899377bb824dcf";
    hash = "sha256-v6ZDREnB+URkgiobIUaadnP95ghHBqlnSzT2ryDTxFY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
  ];

  buildInputs = [
    mesa
    wayland.dev
    libglvnd
    libbsd
    libunwind
    libelf
  ];

  enableParallelBuilding = true;

  configurePhase = ''
    meson setup builddir
  '';

  buildPhase = ''
    cd builddir; meson compile
  '';

  installPhase = ''
    DESTDIR=$out meson install
  '';

  postInstall = ''
    mv $out/usr/local/lib $out/lib
    mv $out/usr/local/share $out/share
    rm -r $out/usr
  '';

  meta = {
    description = "Set of libraries for loading bionic-linked .so files on musl/glibc";
    homepage = "https://gitlab.com/android_translation_layer/bionic_translation";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
})
