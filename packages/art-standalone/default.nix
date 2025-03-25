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
  libpng,
  expat,
  openssl,
  libbsd,
  lz4,
  runtimeShell,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "art-standalone";
  version = "0-unstable-2025-03-24";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "art_standalone";
    rev = "e9d9c2e85af72fccfb6f3621bc1cc041f8f6d338";
    hash = "sha256-aoE3Q1sFMbAoCpVNrsjxaQBm6Kn1gHDcZCSCtAVmDpI=";
  };

  patches = [ ./add-liblog-dep.patch ];

  strictDeps = true;

  nativeBuildInputs = [
    jdk17
    python3
    which
    zip
    pkg-config
  ];

  buildInputs = [
    bionic-translation.out
    expat
    icu
    libbsd
    libcap
    libpng
    lz4
    openssl
    (wolfssl.override {
      extraConfigureFlags = [ "--enable-jni" ];
    })
    xz
    zlib
  ];

  postPatch = ''
    chmod +x dalvik/dx/etc/{dx,dexmerger}
    patchShebangs .
    sed -i "s|/bin/bash|${runtimeShell}|" build/core/config.mk build/core/main.mk
  '';

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
