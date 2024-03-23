{
  inputs,
  poetry2Nix ? inputs.poetry2Nix.packages.default,
  lib,
  fetchFromGitHub,
}:
poetry2Nix.mkPoetryApplication {
  projectDir = fetchFromGitHub {
    owner = "Fabric-Development";
    repo = "fabric";
    rev = "9adb28d7659d9068ff05f1410767334608fa4095";
    hash = "sha256-U9lA+nht23tXoSredZEnXOzW/lTH0rr29nQF5zP9eEo=";
  };
  meta = with lib; {
    description = "Fabric is a python widgets thing framework made for *Nix based systems (Wayland and X11), using GTK+.";
    homepage = "https://github.com/Fabric-Development/Fabric";
    maintainers = with maintainers; [darumaka];
    mainProgram = "mixxc";
    platforms = platforms.linux;
  };
}
