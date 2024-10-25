{
  description = "The packages I use that have not been upstreamed to nixpks";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    cachix-push.url = "github:juspay/cachix-push";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      cachix-push,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.cachix-push.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        {
          config,
          pkgs,
          system,
          self',
          lib,
          ...
        }:
        {
          cachix-push = {
            cacheName = "snowy-cache";
            pathsToCache = {
              devshell = self'.devShells.default;
              inherit (self'.packages)
                bridge-editor
                gh-download
                pokeshell
                kronkhite
                valent
                yoke
                poketex
                waydroid-script
                trashy
                qtscrcpy
                snow-updater
                ;
            };
          };

          formatter = pkgs.nixfmt-rfc-style;

          devShells.default = pkgs.mkShell {
            packages = [
              self'.packages.snow-updater
              pkgs.git
            ];
          };

          packages = {
            bridge-editor = pkgs.callPackage ./packages/bridge { };
            gh-download = pkgs.callPackage ./packages/gh-download { };
            pokeshell = pkgs.callPackage ./packages/pokeshell { };
            mangayomi = pkgs.callPackage ./packages/mangayomi { };
            kronkhite = pkgs.callPackage ./packages/krohnkite { };
            valent = pkgs.callPackage ./packages/valent { stdenv = pkgs.clangStdenv; };
            yoke = pkgs.callPackage ./packages/yoke { };
            poketex = pkgs.callPackage ./packages/poketex { };
            waydroid-script = pkgs.callPackage ./packages/waydroid-script { };
            trashy = pkgs.callPackage ./packages/trashy { };
            qtscrcpy = pkgs.callPackage ./packages/qtscrcpy { };
            snow-updater = pkgs.callPackage ./scripts/default.nix { };
          };
        };
    };
}
