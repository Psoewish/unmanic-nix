{
  lib,
  python312,
  fetchPypi,
}:
let
  buildPythonPackage = python312.pkgs.buildPythonPackage;
in

buildPythonPackage rec {
  pname = "JSON-log-formatter";
  version = "0.5.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-exka5AVkaLryt0RcXOZRvZ7mt2tBYqR5p9hdtq4Cny0=";
  };
  meta = with lib; {
    description = "A simple JSON log formatter for Python";
    homepage = "https://github.com/marselester/json-log-formatter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ marselester ];
  };
}
