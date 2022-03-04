{ pkgs ? <nixpkgs>, lib ? pkgs.lib }:

with pkgs.python3Packages;

buildPythonPackage rec {
  version = "0.14.5";
  pname = "jupyterlab_vim";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9dc4b3318f310e34c82951ea5d6683f67bed7def4b259fafbfe4f1beb1d8e5f";
  };

 propagatedBuildInputs = [
   jupyterlab
   jupyter_console
   qtconsole
   ipywidgets
 ];

  meta = with lib; {
    description = "jupyterlab vim";
    homepage = "https://github.com/jupyterlab-contrib/jupyterlab-vim";
    license = licenses.bsd3;
    platforms = platforms.all;
    priority = 100; 
  };
}
