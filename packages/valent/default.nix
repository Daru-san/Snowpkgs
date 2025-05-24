{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  evolution-data-server-gtk4,
  glib,
  glib-networking,
  gnutls,
  gst_all_1,
  json-glib,
  libadwaita,
  libpeas2,
  libportal-gtk4,
  pulseaudio,
  pipewire,
  sqlite,
  cmake,
  tracker,
  libphonenumber,
}:
stdenv.mkDerivation rec {
  pname = "valent";
  version = "1.0.0.alpha.47-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "andyholmes";
    repo = "valent";
    rev = "737f0a7c1d7bea0cd6b738c549fe00fb8f704f17";
    fetchSubmodules = true;
    hash = "sha256-BNU3ag+lllk4QT8v9nF3xKDbhPfZGFin+4Ss4U5cQ3I=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    cmake
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    evolution-data-server-gtk4
    glib
    glib-networking
    gnutls
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    json-glib
    tracker
    libadwaita
    libpeas2
    libportal-gtk4
    pulseaudio
    sqlite
    pipewire
    libphonenumber
  ];

  mesonFlags = [
    "-Dplugin_bluez=true"
    # FIXME: libpeas2 (and libpeas) not compiled with -Dvapi=true
    "-Dvapi=false"
  ];

  meta = {
    description = "Implementation of the KDE Connect protocol, built on GNOME platform libraries";
    mainProgram = "valent";
    longDescription = ''
      Note that you have to open firewall ports for other devices
      to connect to it. Use either:
      ```nix
      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      }
      ```
      or open corresponding firewall ports directly:
      ```nix
      networking.firewall = rec {
        allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      }
      ```
    '';
    homepage = "https://valent.andyholmes.ca";
    changelog = "https://github.com/andyholmes/valent/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
      cc0
      cc-by-sa-30
    ];
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
