{ lib, python312 }:
let
  sources = import ./npins;
  py = python312.pkgs;

  packageOverrides = {
    inquirer = {
      format = "pyproject";
      nativeBuildInputs = [ py.poetry-core ];
      propagatedBuildInputs = with py; [
        blessed
        editor
        readchar
      ];
    };
    marshmallow = {
      format = "pyproject";
      nativeBuildInputs = [ py.flit-core ];
    };
  };

  # Helper function to generate PyPi packages from npins sources
  buildFromNpins =
    name: src:
    py.buildPythonPackage (
      {
        pname = src.name;
        version = src.version;
        format = "setuptools";

        src = builtins.fetchurl {
          url = src.url;
          sha256 = src.hash;
        };

        meta.lib.description = "Python package ${name}";
      }
      // packageOverrides.${name} or { }
    );
in
lib.mapAttrs buildFromNpins sources
