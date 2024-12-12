{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_periodic_table";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "JosephTLyons";
    repo = "nu_plugin_periodic_table";
    tag = "v${version}";
    hash = "sha256-zeErTvjR4sQ0nKSc3KpMMxHZ1kl7h8+suRVWkuiNYZ4=";
  };

  cargoHash = "sha256-6SoMhc1xRXdpzEM/LxagSqaoZhXy2GrkbPRvtd3ziNM=";

  cargoBuildFlags = [ "--package nu_plugin_periodic_table" ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.IOKit
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Periodic table plugin for nushell";
    homepage = "https://github.com/JosephTLyons/nu_plugin_periodic_table";
    changelog = "https://github.com/JosephTLyons/nu_plugin_periodic_table/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "nu_plugin_periodic_table";
  };
}
