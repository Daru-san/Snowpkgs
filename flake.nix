{
  description = "The packages I use that have not been upstreamed to nixpks";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    genSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
    pkgsFor = nixpkgs.legacyPackages;
  in {
    overlays.default = _: prev: {
      bridge-editor = prev.callPackage ./packages/bridge {};
      gh-s = prev.callPackage ./packages/gh-s {};
      gh-download = prev.callPackage ./packages/gh-download {};
      fabric = prev.callPackage ./packages/fabric {};
      pokeshell = prev.callPackage ./packages/pokeshell {};
      zaread = prev.callPackage ./packages/zaread {};
      lexido = prev.callPackage ./packages/lexido {};
      mangayomi = prev.callPackage ./packages/mangayomi {};
      git-nautilus-icons = prev.callPackage ./packages/git-nautilus-icons {};
      kronkhite = prev.callPackage ./packages/krohnkite {};
      hyprlandPlugins = nixpkgs.lib.recurseIntoAttrs (prev.callPackage ./packages/hyprland-plugins {});
    };

    packages = genSystems (system: self.overlays.default null pkgsFor.${system});

    formatter = genSystems (system: pkgsFor.${system}.alejandra);
  };
}
