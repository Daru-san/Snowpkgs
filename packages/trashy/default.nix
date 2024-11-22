{
  lib,
  rustPlatform,
  installShellFiles,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "trashy";
  version = "2.0.0-unstable-2024-11-21";

  src = fetchFromGitHub {
    owner = "Daru-san";
    repo = "trashy";
    rev = "2d17f37051a0d710ebd91ba0cc2f2df1adfa4947";
    hash = "sha256-JttOyWa09HktH9ep/GTYoCr9DvbreSRqfmSjEdi347I=";
  };

  cargoHash = "sha256-wa+Vslvjpu3RKPPlQ/wj29jrUwt7qboo+1eRFoNhmqw=";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    installShellCompletion --cmd trashy \
      --bash <($out/bin/trashy completions bash) \
      --fish <($out/bin/trashy completions fish) \
      --zsh <($out/bin/trashy completions zsh) \
  '';

  meta = with lib; {
    description = "Simple, fast, and featureful alternative to rm and trash-cli";
    homepage = "https://github.com/oberblastmeister/trashy";
    changelog = "https://github.com/oberblastmeister/trashy/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ maintainers.daru-san ];
    mainProgram = "trashy";
    platforms = platforms.linux;
  };
}
