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
    hash = "";
  };
  meta = with lib; {
    description = "Python web framework and asynchronous networking library";
    homepage = "https://github.com/tornadoweb/tornado";
    license = licenses.Apache-2;
    maintainers = with maintainers; [ tornadoweb ];
  };
}
