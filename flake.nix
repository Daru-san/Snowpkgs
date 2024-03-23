{
  description = "A flake for packages I use that aren't packaged in nixpkgs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    poetry2Nix.url = "github:nix-community/poetry2nix";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
    };
}
