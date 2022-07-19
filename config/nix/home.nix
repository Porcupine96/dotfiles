{ pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
  services.lorri.enable = true;

  home = {
    packages = with pkgs; [
      # Core
      arandr
      bat
      blueman
      bluez
      curl
      direnv
      dunst
      fd
      feh
      fish
      flameshot
      fzf
      htop-vim
      i3blocks
      libreoffice-fresh
      # i3lock py # TODO: mypy-protobuf
      pyright

      # jupyter
      (let
        # jupyterlab_vim = callPackage ./python/jupyterlab_vim.nix {};

        my-python-packages = python-packages:
          with python-packages; [
            black
            pip
            pandas
            regex
            idasen
            virtualenv
            mypy-protobuf
            grpcio
            grpcio-tools
            tqdm
          ];
        python-with-my-packages = python3.withPackages my-python-packages;
      in python-with-my-packages)

      # other
      ansible
      (gl_wrap pkgs {
        bin = "anki";
        package = anki-bin;
      })
      # freetube # <- issue with audio
      (gl_wrap pkgs { bin = "brave"; })
      (gl_wrap pkgs { bin = "firefox"; })
      # burpsuite
      calibre
      copyq
      coursier
      dropbox
      google-cloud-sdk
      gron
      grpcurl
      home-assistant-cli
      httpie
      isync
      jq
      kubectl
      kustomize
      k9s
      languagetool
      mu
      ngrok
      (gl_wrap pkgs {
        bin = "obs";
        package = obs-studio;
      })
      ocrmypdf
      pandoc
      postman
      pdftk
      pgcli
      pup
      robo3t
      termdown
      tmpmail
      up
      (gl_wrap pkgs { bin = "zeal"; })
      zathura
      zip
    ];

    stateVersion = "20.09";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGcc;
    extraPackages = (epkgs:
      [
        epkgs.vterm
        # epkgs.pdf-tools
      ]);
  };

}
