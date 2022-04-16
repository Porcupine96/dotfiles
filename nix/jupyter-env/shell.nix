{ pkgs ? import <nixpkgs> { } }:
let
  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "93f75799b527b03de9acc09ae18cc4b8817fb0c5";
  }) {};

  python-packages = p: with p; [
    numpy
    matplotlib
    seaborn
    pandas
  ];

  python-der = pkgs.python39.withPackages python-packages;

  iPython = jupyter.kernels.iPythonWith {
    name = "notebook";
    packages = python-packages;
  };

  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython ];
      directory = jupyter.mkDirectoryWith {
        extensions = [ "@axlair/jupyterlab_vim" ];
      };
    };
in
with pkgs;
jupyterEnvironment.env.overrideAttrs (old: {
  buildInputs = [python-der] ++ old.buildInputs;
  shellHook = old.shellHook;
})
