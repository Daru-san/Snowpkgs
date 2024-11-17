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
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ flake-parts.flakeModules.easyOverlay ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      flake = {
        homeManagerModules = {
          elia = flake-parts.lib.importApply ./modules/elia.nix { inherit inputs; };
        };
      };
      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          overlayAttrs = {
            inherit (config) packages;
          };
          devShells.default = pkgs.mkShellNoCC {
            packages = [ config.packages.snow-updater ];
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
            rqbit-testing = pkgs.callPackage ./packages/rqbit { };
            elia = pkgs.callPackage ./packages/elia { };
            snow-updater = pkgs.callPackage ./scripts/default.nix { };
          };
        };
    };
}
