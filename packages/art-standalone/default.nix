{
  lib,
  stdenv,
  fetchFromGitLab,
  wolfssl,
  bionic-translation,
  python3,
  which,
  jdk17,
  zip,
  xz,
  icu,
  zlib,
  libcap,
  expat,
  openssl,
  libbsd,
  lz4,
  runtimeShell,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "art-standalone";
  version = "0-unstable-2025-03-05";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "art_standalone";
    rev = "c159b1618e01221ac05811f37743a786c46e68fc";
    hash = "sha256-WmvudYCntfmUoNA6qWLcCscUK4Wb0Soojqnz7F0YL3A=";
  };

  patches = [ ./add-liblog-dep.patch ];

  enableParallelBuilding = true;

  strictDeps = true;

  nativeBuildInputs = [
    jdk17
    python3
    which
    zip
    pkg-config
  ];

  buildInputs = [
    bionic-translation
    expat
    icu
    libbsd
    libcap
    lz4
    openssl
    wolfssl
    xz
    zlib
  ];

  postPatch = ''
    chmod +x dalvik/dx/etc/{dx,dexmerger}
    patchShebangs .
    sed -i "s|/bin/bash|${runtimeShell}|" build/core/config.mk build/core/main.mk
  '';

  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
    "-w"
    "-fsyntax-only"
  ];

  makeFlags = [
    "____LIBDIR=lib"
    "____PREFIX=${placeholder "out"}"
    "____INSTALL_ETC=${placeholder "out"}/etc"
  ];

  meta = {
    description = "Art and dependencies with modifications to make it work on Linux";
    homepage = "https://gitlab.com/android_translation_layer/art_standalone";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
})
