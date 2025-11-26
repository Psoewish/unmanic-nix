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

  preBuild = ''
    # Initialize dummy git repository for automatic versioning
    git init
    git config user.email "build@nix"
    git config user.name "Nix Builder"
    git add -A
    git commit -m "Build version"
    git tag ${version}

    # Set the frontend cache location, then copy files and build the frontend manually
    export npm_config_cache=${npmDepsFrontend}
    cp -r unmanic/webserver/frontend ./frontend_build
    npm ci --offline --prefix ./frontend_build
    patchShebangs ./frontend_build/node_modules/
    npm run build:publish --prefix ./frontend_build

    # Make sure the result from the frontend build is copied to the public directory
    mkdir -p ./unmanic/webserver/public
    cp -r ./frontend_build/dist/spa/* ./unmanic/webserver/public/
    echo "checking public directory post-copy"

    # Skip the python script's frontend build, since we're already building it manually
    sed -i "s/self.run_command('build-frontend')/# self.run_command('build-frontend')/" setup.py
  '';

  postInstall = ''
    # Make sure all the frontend files are in the correct final store location
    mkdir -p $out/lib/python3.12/site-packages/unmanic/webserver/public
    cp -r ./unmanic/webserver/public/* $out/lib/python3.12/site-packages/unmanic/webserver/public/ || true
  '';

  meta = with lib; {
    description = "Media library optimizer";
    homepage = "https://github.com/Unmanic/unmanic";
    license = licenses.gpl3Only;
    mainProgram = "unmanic";
  };
}
