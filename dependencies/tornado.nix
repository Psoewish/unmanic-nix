{
  lib,
  python312,
  fetchPypi,
}:
let
  buildPythonPackage = python312.pkgs.buildPythonPackage;
in

buildPythonPackage rec {
  pname = "tornado";
  version = "6.3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-59jbQcAYHIDXbJgqrMRCwHg6LFTWQA/gKJVCAaLgMv4=";
  };
  meta = with lib; {
    description = "Python web framework and asynchronous networking library";
    homepage = "https://github.com/tornadoweb/tornado";
    license = licenses.asl20;
    maintainers = with maintainers; [ tornadoweb ];
  };
}
