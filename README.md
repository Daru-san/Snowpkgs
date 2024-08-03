# Snowpkgs

My custom flake repo with a few packages I use that aren't found in the nixpkgs repo.

Most of these packages are pushed to a binary cache, so manually building is not necessary

New packages added every once in a while

## Available packages

<!--markdownlint-disable-->

| Package                               | Description                                                                 | url                                             |
| ------------------------------------- | --------------------------------------------------------------------------- | ----------------------------------------------- |
| Bridge _(attribute is bridge-editor)_ | A minecraft addon IDE                                                       | <https://bridge-core.app/>                      |
| Valent _(development version)_        | A kde-connect like app, written in GTK                                      | <https://github.com/andyholmes/valent>          |
| Mangayomi _(won't build)_             | An comprehensive anime player and manga reader with anilist and MAL syncing | <https://github.com/kodjodevf/mangayomi>        |
| Pokeshell                             | A pokemon terminal program for displaying pokemon sprites, with animation   | <https://github.com/acxz/pokeshell>             |
| Yoke                                  | A program that lets you use your phone as a gamepad                         | <https://github.com/rmst/yoke>                  |
| krohnkite _(forked)_                  | A kwin tiling extension                                                     | <https://github.com/anametologin/krohnkite>     |
| Poketex                               | A pokedex for the terminal, written in rust                                 | <https://github.com/ckaznable/poketex>          |
| Trashy (updated upstream)             | A nice shell alternative to the rm command                                  | <https://github.com/oberblastmeister/trashy>    |
| waydroid-script                       | A script for waydroid with cool features like enabling root access          | <https://github.com/casualsnek/waydroid_script> |

<!--markdownlint-restore-->

## Usage

I recommend using flakes to set use these packages:

### Run without installing

<!--markdownlint-disable-->

```bash
nix shell github:Daru-san/Snowpkgs#bridge-editor --extra-substituters https://snowy-cache.cachix.org --extra-trusted-public-keys snowy-cache.cachix.org-1:okWl5IF/yzdZ+p/eRhDFvcanQo/y0ta80dvfdGgy28U=
```

<!--markdownlint-restore-->

### Installation using flakes

```nix
#flake.nix
{
  description = "your flake";
  inputs = {
    nixpkgs.url = "nixos/nixos-unstable";
    snowpkgs.url = "github:Daru-san/Snowpkgs"; # or sourcehut:~darumaka/Snowpkgs

    # Avoid doing following the nixpkgs input, it may (will) cause cache issues
    # snowpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Use the overlay

```nix
{inputs,...}:{
  nixpkgs.overlays = [
    inputs.snowpkgs.overlays.default
  ];
}
```

Add packages

```nix
# home.nix
{
  home.packages = [pkgs.bridge-editor];
}
# OR
# configuration.nix
{
  environment.systemPackages = [pkgs.bridge-editor];
}
```

## Using binary caches

Use the binary caches to prevent building manually

```nix
# configuration.nix
{
  nix.settings = {
    builders-use-substitutes = true;
    substituters = [
      "https://snowy-cache.cachix.org"
    ];

    trusted-public-keys = [
      "snowy-cache.cachix.org-1:okWl5IF/yzdZ+p/eRhDFvcanQo/y0ta80dvfdGgy28U="
    ];
  };
}

```
