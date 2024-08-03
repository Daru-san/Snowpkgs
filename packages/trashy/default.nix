{
  lib,
  rustPlatform,
  installShellFiles,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "trashy";
  version = "unstable-2024-06-01";

  src = fetchFromGitHub {
    owner = "Daru-san";
    repo = "trashy";
    rev = "34dfc987e775115cb1d66839cc73d48be9048e65";
    hash = "sha256-nv5Jodx65fctNng0HUMB+YyDgSW7W/V1ln+FqyfgfRo=";
  };

  cargoHash = "sha256-ZWqWtWzb+CLH1ravBb/oV+aPxplEyiC1wEFhvchcLqg=";

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
