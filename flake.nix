{
  description = "The packages I use that have not been upstreamed to nixpks";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      genSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      overlays.default = _: prev: {
        bridge-editor = prev.callPackage ./packages/bridge { };
        gh-download = prev.callPackage ./packages/gh-download { };
        pokeshell = prev.callPackage ./packages/pokeshell { };
        mangayomi = prev.callPackage ./packages/mangayomi { };
        kronkhite = prev.callPackage ./packages/krohnkite { };
        valent = prev.callPackage ./packages/valent { stdenv = prev.clangStdenv; };
        yoke = prev.callPackage ./packages/yoke { };
	poketex = prev.callPackage ./packages/poketex { };
        waydroid-script = prev.callPackage ./packages/waydroid-script { };
      };

      packages = genSystems (system: self.overlays.default null pkgsFor.${system});

      formatter = genSystems (system: pkgsFor.${system}.nixfmt-rfc-style);
    };
}
