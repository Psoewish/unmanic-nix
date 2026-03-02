# Notice
A new version is now out, I'm currently working on updating this flake, however 0.4.0 seems to have brought quite a few changes that make it harder than just updating some versions/hashes, and I'll have to debug the install script again lol. I'll try to get this working ASAP but for now 0.3.0 still works perfectly fine. Apologies for the delay if anyone actually uses (and reads) this.

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
