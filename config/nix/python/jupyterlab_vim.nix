{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.14.5 ";
  pname = "jupyterlab_bim";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9dc4b3318f310e34c82951ea5d6683f67bed7def4b259fafbfe4f1beb1d8e5f";
  };

  doCheck = false;

  meta = with lib; {
    description = "jup";
    homepage = "https://github.com/jupyterlab-contrib/jupyterlab-vim";
    license = licenses.bsd3;
    platforms = platforms.all;
    priority = 100; 
  };

}
