{
  lib,
  rustPlatform,
  fetchCrate,
  cmake,
  pkgconf,
  wayland,
  qalculate,
  freetype,
  expat,
  makeWrapper,
  vulkan-loader,
  libglvnd,
  pop-launcher,
}:
rustPlatform.buildRustPackage rec {
  pname = "onagre";
  version = "1.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "";
  };

  cargoHash = "";

  nativeBuildInputs = [cmake pkgconf makeWrapper];
  buildInputs = [freetype expat qalculate pop-launcher wayland];

  postFixup = let
    rpath = lib.makeLibraryPath buildInputs;
  in ''
    patchelf --set-rpath ${rpath} $out/bin/onagre
    wrapProgram $out/bin/onagre \
      --prefix PATH ':' ${lib.makeBinPath [pop-launcher]}
  '';

  meta = with lib; {
    description = "A general purpose application launcher for X and wayland inspired by rofi/wofi and alfred";
    homepage = "https://github.com/oknozor/onagre";
    license = licenses.mit;
    maintainers = [maintainers.jfvillablanca];
    platforms = platforms.linux;
    mainProgram = "onagre";
  };
}
