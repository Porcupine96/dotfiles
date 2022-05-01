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
      libreoffice
      # i3lock TODO: doesn't work 
      (gl_wrap pkgs { bin = "kitty"; })
      neofetch
      man-db
      gnome.nautilus
      jdk
      neovim
      noto-fonts
      (gl_wrap pkgs { bin = "imv"; })
      (gl_wrap pkgs { bin = "picom"; })
      (polybar.override {
        i3Support = true;
      })
      protobuf # TODO: remove from pacman (python-protobuf, protobuf-c conflicts)
      (pass.withExtensions (ext: [ ext.pass-otp ]))
      rofi
      ripgrep
      rsync
      sd
      spicetify-cli
      tmux
      unrar
      wget
      vifm

      # nix
      cachix
      nixGLIntel
      nixfmt

      # LaTeX
      (texlive.combine {
        inherit (texlive)
          scheme-medium minted wrapfig capt-of fvextra upquote catchfile xstring
          kvoptions fancyvrb pdftexcmds etoolbox xcolor lineno framed;
      })

      # Scala
      ammonite
      sbt

      # JS
      yarn

      # Python
      mypy # TODO: mypy-protobuf
      pyright

      (let
        # jupyterlab_vim = callPackage ./python/jupyterlab_vim.nix {};

        my-python-packages = python-packages:
          with python-packages; [
            black
            pip
            pandas
            idasen
            # jupyterlab
            # jupyterlab_vim
            virtualenv
            mypy-protobuf
            # temporary
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
      # ferdi <- issue with audio
      (gl_wrap pkgs { bin = "brave"; })
      (gl_wrap pkgs { bin = "firefox"; })
      # burpsuite
      copyq
      coursier
      dropbox
      google-cloud-sdk
      gron
      grpcurl
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
      tmpmail
      up
      (gl_wrap pkgs { bin = "zeal"; })
      zathura
    ];

    stateVersion = "20.09";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGcc;
    extraPackages = (epkgs: [ epkgs.vterm epkgs.pdf-tools ]);
  };
}
