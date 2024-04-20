{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  src = fetchFromGitHub {
    owner = "darkhz";
    repo = "adbtuifm";
    rev = "7a845e59e28d9c3ab5009a723a20c2d2dab387e4";
    hash = "sha256-TK93O9XwMrsrQT3EG0969HYMtYkK0a4PzG9FSTqHxAY=";
  };
}
