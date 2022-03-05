{ pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      # Core
      arandr
      bat
      blueman
      curl
      fd
      feh
      flameshot
      fzf
      i3blocks
      # i3lock TODO: doesn't work 
      (gl_wrap pkgs { bin = "kitty"; })
      neofetch
      neovim
      (gl_wrap pkgs { bin = "imv"; })
      (gl_wrap pkgs { bin = "picom"; })
      protobuf # TODO: remove from pacman (python-protobuf, protobuf-c conflicts)
      (pass.withExtensions (ext: [ ext.pass-otp ]))
      rofi
      ripgrep
      rsync
      tmux
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
        jupyterlab_vim = callPackage ./python/jupyterlab_vim.nix {};

        my-python-packages = python-packages:
          with python-packages; [
            pip 
            pandas
            idasen
            jupyterlab
            jupyterlab_vim
            virtualenv
          ];
        python-with-my-packages = python3.withPackages my-python-packages;
      in python-with-my-packages)

      # other
      ansible
      (gl_wrap pkgs {
        bin = "anki";
        package = anki-bin;
      })
      # freetube <- issue with audio
      # ferdi <- issue with audio
      copyq
      dropbox
      grpcurl
      httpie
      jq
      kubectl
      kustomize
      k9s
      languagetool
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
      robo3t # TODO: fix QT scaling - "don't scale my apps" in Kuba's config
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
