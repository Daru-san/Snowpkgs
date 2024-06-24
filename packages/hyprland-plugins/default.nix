{
  lib,
  callPackage,
  pkg-config,
  stdenv,
  hyprland,
}: let
  mkHyprlandPlugin = hyprland: args @ {pluginName, ...}:
    stdenv.mkDerivation (args
      // {
        pname = "${pluginName}";
        nativeBuildInputs = [pkg-config] ++ args.nativeBuildInputs or [];
        buildInputs =
          [hyprland]
          ++ hyprland.buildInputs
          ++ (args.buildInputs or []);
      });

  plugins = {
    hyprspace = {
      fetchFromGitHub,
      hyprland,
    }:
      mkHyprlandPlugin hyprland {
        pluginName = "hyprspace";
        version = "unstable-2024-06-17";

        src = fetchFromGitHub {
          owner = "KZDKM";
          repo = "Hyprspace";
          rev = "2f3edb68f47a8f5d99d10b322e9a85a285f53cc7";
          hash = "sha256-iyj4D6c77uROAH9QdZjPd9SKnS/DuACMESqaEKnBgI8=";
        };

        installPhase = ''
          make all
        '';

        dontStrip = true;
      };
    hycov = {
      fetchFromGitHub,
      cmake,
      hyprland,
    }:
      mkHyprlandPlugin hyprland {
        pluginName = "hycov";
        version = "unstable-2024-06-20";

        src = fetchFromGitHub {
          owner = "DreamMaoMao";
          repo = "hycov";
          rev = "6748bde85fa3a4f82cf8b038a6538f12f9f27428";
          hash = "sha256-NRnxbkuiq1rQ+uauo7D+CEe73iGqxsWxTQa+1SEPnXQ=";
        };

        nativeBuildInputs = [cmake];

        dontStrip = true;
      };
  };
in
  (lib.mapAttrs (name: plugin: callPackage plugin {}) plugins) // {inherit mkHyprlandPlugin;}
