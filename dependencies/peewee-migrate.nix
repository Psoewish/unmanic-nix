{
  lib,
  python312,
  fetchPypi,
}:
let
  buildPythonPackage = python312.pkgs.buildPythonPackage;
in

buildPythonPackage rec {
  pname = "peewee-migrate";
  version = "1.6.1";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2rODfxxsMDIB9D1RquGAfLOWRKv4IsGqQ7uf7K2PYrw=";
  };
  meta = with lib; {
    description = "A simple database migration tool for Peewee";
    homepage = "https://github.com/klen/peewee-migrate";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ klen ];
  };
}
