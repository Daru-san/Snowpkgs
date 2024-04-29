{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "lexido";
  version = "1.4";
  src = fetchFromGitHub {
    owner = "micr0-dev";
    repo = "lexido";
    rev = "v${version}";
    hash = "sha256-7T/5lWMjpzVGNqKBWcJ/Ux7rhtjIepz/a+aWmB8Z+Do=";
  };
  vendorHash = "sha256-voVoowjM90OGWXF4REEevO8XEzT7azRYiDay4bnGBks=";
  meta = with lib; {
    description = "An innovative assistant for the command line";
    homepage = "https://github.com/micr0-dev/lexido";
    changelog = "https://github.com/micr0-dev/lexido/releases/tag/v${version}";
    license = with licenses; [mit];
    maintainers = with maintainers; [daru-san];
    mainProgram = "lexido";
    platforms = platforms.linux;
  };
}
