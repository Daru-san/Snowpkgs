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
