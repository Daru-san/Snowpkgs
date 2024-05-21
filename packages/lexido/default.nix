{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "lexido";
  version = "1.4.2";
  src = fetchFromGitHub {
    owner = "micr0-dev";
    repo = "lexido";
    rev = "v${version}";
    hash = "sha256-nc6UvW16MmLsKt0oSb9nG64N7J3+5CveSwPnGOezhGY=";
  };
  vendorHash = "sha256-h3ws9k7W4nNyS1WvZP29NJfJsBOe0D47ykd41C96Xi4=";
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
