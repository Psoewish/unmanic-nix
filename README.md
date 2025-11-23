# Unmanic for NixOS

A Nix flake providing [Unmanic](https://github.com/Unmanic/unmanic), a library optimizer for your media files.

## Disclaimer

This project is not an official Unmanic project. It's really just a personal project that I've decided to share with the community, so I really can't vouch for it's quality or stability (or even best practices, honestly). Use at your own risk. etc. etc.
Though if you do encounter any issues or have any questions, do feel free to reach out and I'll do my best to help.

## Versioning

I will try to follow Unmanic's major tagged releases, which at the time of writing this, is version 0.3.0.

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
  dataDir = "/mnt/storage/unmanic";
  user = "unmanic";
  group = "unmanic";
};
```

## License

This package follows the main Unmanic license, which is GPL-3.0. All the work, rights, credits, praise, etc. are given to the official Unmanic team. Here's a copy of the license agreement in the official Unmanic repository.
 
###### Written by: Psoewish
###### Date: Sunday November 23 2025
 
Copyright:
       Copyright (C) Josh Sunnex - All Rights Reserved
 
       Permission is hereby granted, free of charge, to any person obtaining a copy
       of this software and associated documentation files (the "Software"), to deal
       in the Software without restriction, including without limitation the rights
       to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
       copies of the Software, and to permit persons to whom the Software is
       furnished to do so, subject to the following conditions:
  
       The above copyright notice and this permission notice shall be included in all
       copies or substantial portions of the Software.
  
       THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
       EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
       MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
       IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
       DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
       OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
       OR OTHER DEALINGS IN THE SOFTWARE.
