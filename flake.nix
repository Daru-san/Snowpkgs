{
  description = "The packages I use that have not been upstreamed to nixpks";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      self,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        imports = [ flake-parts.flakeModules.easyOverlay ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        flake = {
          homeManagerModules.default =
            { pkgs, ... }:
            {
              imports = [ ./modules/elia.nix ];
              programs.elia.package = withSystem pkgs.stdenv.hostPlatform.system (
                { config, ... }: config.packages.elia
              );
            };
        };
        perSystem =
          {
            config,
            pkgs,
            ...
          }:
          {
            overlayAttrs = config.packages;
            devShells.default = pkgs.mkShellNoCC {
              packages = [ config.packages.snow-updater ];
            };
            packages = {
              bridge-editor = pkgs.callPackage ./packages/bridge { };
              gh-download = pkgs.callPackage ./packages/gh-download { };
              pokeshell = pkgs.callPackage ./packages/pokeshell { };
              kronkhite = pkgs.callPackage ./packages/krohnkite { };
              valent = pkgs.callPackage ./packages/valent { stdenv = pkgs.clangStdenv; };
              yoke = pkgs.callPackage ./packages/yoke { };
              poketex = pkgs.callPackage ./packages/poketex { };
              waydroid-script = pkgs.callPackage ./packages/waydroid-script { };
              trashy = pkgs.callPackage ./packages/trashy { };
              nu-periodic-table = pkgs.callPackage ./packages/nushell-periodic-table/default.nix { };

              # Waiting for upstream to update tauri version with next release
              # rqbit-testing = pkgs.callPackage ./packages/rqbit { };

              # elia = pkgs.callPackage ./packages/elia { };
              snow-updater = pkgs.callPackage ./scripts/default.nix { };
            };
            formatter = pkgs.nixfmt-rfc-style;
          };
      }
    );
}
