{
  description = "Unmanic - Library Optimizer for media files";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    flakelight.url = "github:nix-community/flakelight";
  };

  outputs =
    { flakelight, ... }:
    flakelight ./. {
      package = import ./package.nix;
      nixosModule = ./module.nix;
    };
}
