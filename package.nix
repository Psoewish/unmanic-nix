{
  lib,
  python312,
  pkgs,
  fetchFromGitHub,
  fetchNpmDeps,
  ffmpeg,
  nodejs,
  git,
}:
let
  buildPythonPackage = python312.pkgs.buildPythonPackage;
  json-log-formatter = pkgs.callPackage ./dependencies/json-log-formatter.nix { };
  peewee-migrate = pkgs.callPackage ./dependencies/peewee-migrate.nix { };
  tornado = pkgs.callPackage ./dependencies/tornado.nix { };
in
buildPythonPackage rec {
  pname = "unmanic";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Unmanic";
    repo = "unmanic";
    rev = version;
    hash = "sha256-7raWy/3VhD/J7otkYYcHEdntg+UMxpp9GcSoT3ZVWVI=";
    fetchSubmodules = true;
  };

  # Grab frontend submodule dependencies
  npmDepsFrontend = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/unmanic/webserver/frontend";
    hash = "sha256-BjF2gKv8Ty4Bhc//nR7ecS0/Mdctm8/WOiRhFn+dEHc=";
  };

  nativeBuildInputs = [
    nodejs
    git
  ];

  propagatedBuildInputs = with python312.pkgs; [
    schedule
    tornado
    marshmallow
    peewee
    peewee-migrate
    psutil
    requests
    requests-toolbelt
    py-cpuinfo
    watchdog
    inquirer
    swagger-ui-py
    json-log-formatter
  ];

  dependencies = [
    ffmpeg
  ];

  patches = [
    # Patch npm ci so that it uses an offline cache instead
    # Not doing this will result in errors, as no network access is available during the build process
    ./patches/use_npm_cache.patch

    # Patch the setup to define a subprocess for shebang patching
    # npm run needs this to function.
    ./patches/patch_shebangs.patch
  ];

  preBuild = ''
    # Initialize dummy git repository for automatic versioning
    git init
    git config user.email "build@nix"
    git config user.name "Nix Builder"
    git add -A
    git commit -m "Build version"
    git tag ${version}

    # Set the frontend cache location, so our offline-build patch can use it
    export npm_config_cache=${npmDepsFrontend}
  '';

  meta = with lib; {
    description = "Media library optimizer";
    homepage = "https://github.com/Unmanic/unmanic";
    license = licenses.gpl3Only;
    mainProgram = "unmanic";
  };
}
