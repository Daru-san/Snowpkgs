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
  version = "0-unstable-2025-04-14";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "art_standalone";
    rev = "460c65431c84e08a55d5f2bd3ba549b6f375efd1";
    hash = "sha256-oGFu6TnVa1sz9QVxql1nO9ZWUAmyOnna6x3915JL09Y=";
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
