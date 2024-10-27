let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    ref = "refs/tags/3.5.0";  
  }) {
    python = "python39";
  };

  python-env = mach-nix.mkPython rec {
    requirements = ''
      numpy
      matplotlib
      seaborn
      pandas
    '';

    # requirements = builtins.readFile ./requirements.txt;
  };

  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "79dd05b3d703cd0034296dd367422f7298fe99d6";
  }) {};

  iPython = jupyter.kernels.iPythonWith {
    name = "basic-python";
    python3 = python-env.python;
    packages = python-env.python.pkgs.selectPkgs;
  };

  jupyterEnvironment = jupyter.jupyterlabWith {
    kernels = [ iPython ];
  };
in
 jupyterEnvironment.env
