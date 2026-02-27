# Notice
A new version is now out, so I'll update this flake soon. Going forward I think I'll create a new branch for each version (in case you want to easily track an older version), while main will always be the latest version.
No ETA on when I'll update this, but should be within a week as of writing this (feb 27)

# Unmanic for NixOS

A Nix flake providing [Unmanic](https://github.com/Unmanic/unmanic), a library
optimizer for your media files.

## Disclaimer

This project is not an official Unmanic project. It's really just a personal
project that I've decided to share with the community, so I really can't vouch
for it's quality or stability (or even best practices, honestly). Use at your
own risk. etc. etc. Though if you do encounter any issues or have any questions,
do feel free to reach out and I'll do my best to help.

## Versioning

I will try to follow Unmanic's major tagged releases, which at the time of
writing this, is version 0.3.0.

## Usage

Add this flake to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unmanic-nix.url = "github:psoewish/unmanic-nix";
  };

  outputs = { self, nixpkgs, unmanic-nix, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      modules = [
        unmanic-nix.nixosModules.default
        {
          services.unmanic.enable = true;
        }
      ];
    };
  };
}
```

### Example Configuration

#### These also happen to be all the options you can configure, with their default values :)

```nix
services.unmanic = {
  enable = true;
  port = 8888;
  dataDir = "/var/lib/unmanic";
  user = "unmanic";
  group = "unmanic";
  extraGroups = [ "video" "render" ];
  openFirewall = false;
};
```

## License

This package follows the main Unmanic license, which is GPL-3.0. All the work,
rights, credits, praise, etc. are given to the official Unmanic team.
