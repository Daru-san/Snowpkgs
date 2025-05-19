{
  description = "The packages I use that have not been upstreamed to nixpks";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fabric.url = "github:Fabric-Development/fabric";
  };

  outputs =
    inputs@{
      flake-parts,
      fabric,
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
            packages = rec {
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
              seanime = pkgs.callPackage ./packages/seanime { };
              mtkclient = pkgs.callPackage ./packages/mtkclient { };
              bionic-translation = pkgs.callPackage ./packages/bionic-translation { };
              palsp = pkgs.callPackage ./packages/palsp { };
              pasls = pkgs.callPackage ./packages/pasls { };
              jcf-pascal-format = pkgs.callPackage ./packages/jcf-pascal-format { };

              # art-standalone = pkgs.callPackage ./packages/art-standalone { inherit bionic-translation; };
              #
              # android-translation-layer = pkgs.callPackage ./packages/android-translation-layer {
              #   inherit bionic-translation art-standalone;
              # };
              xbyak = pkgs.callPackage ./packages/xbyak/xbyak.nix { };
              xbyak-aarch64 = pkgs.callPackage ./packages/xbyak/xbyak-aarch64.nix { };

              tanuki3ds = pkgs.callPackage ./packages/tanuki3ds { inherit xbyak xbyak-aarch64; };

              # # Waiting for upstream to update tauri version with next release
              # rqbit-testing = pkgs.callPackage ./packages/rqbit { };

              rlottie-python = pkgs.callPackage ./packages/rlottie-python { inherit py-build-cmake; };

              py-build-cmake = pkgs.callPackage ./packages/py-build-cmake { };

              hydepanel = pkgs.callPackage ./packages/hydepanel {
                fabric = inputs.fabric.packages.${pkgs.system}.default;
                inherit rlottie-python;
              };

              clipse-gui = pkgs.callPackage ./packages/clipse-gui { };

              # elia = pkgs.callPackage ./packages/elia { };
              snow-updater = pkgs.callPackage ./scripts/default.nix { };
            };
            formatter = pkgs.nixfmt-rfc-style;
          };
      }
    );
}
