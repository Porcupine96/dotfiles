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
      # i3lock TODO: doesn't work 
      (gl_wrap pkgs { bin = "kitty"; })
      neofetch
      man-db
      gnome.nautilus
      openjdk11
      neovim
      noto-fonts
      noto-fonts-emoji
      (gl_wrap pkgs { bin = "imv"; })
      (gl_wrap pkgs { bin = "picom"; })
      (polybar.override { i3Support = true; })
      protobuf # TODO: remove from pacman (python-protobuf, protobuf-c conflicts)
      (pass.withExtensions (ext: [ ext.pass-otp ]))
      (rofi.override { plugins = [ rofi-emoji ]; })
      ripgrep
      rsync
      sd
      symbola
      spicetify-cli
      tmux
      tree
      unrar
      wget
      vifm
      xclip

      # mongo

      # nix
      cachix
      nixGLIntel
      nixfmt

      # LaTeX
      (texlive.combine {
        inherit (texlive)
        scheme-medium minted wrapfig capt-of fvextra upquote catchfile xstring
        kvoptions fancyvrb pdftexcmds etoolbox xcolor lineno framed ucs preprint
        cm-super unicode-math libertine;
      })

      # Scala
      ammonite
      sbt
      scala_2_13
      scalafmt

      # JS
      yarn

      # Python
      mypy # TODO: mypy-protobuf
      pyright

      # jupyter
      (let
        # jupyterlab_vim = callPackage ./python/jupyterlab_vim.nix {};

        my-python-packages = python-packages:
        with python-packages; [
          black
          pip
          pandas
          poetry
          regex
          idasen
          ipykernel
          ipython
          virtualenv
          matplotlib
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
      # calibre
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
      languagetool
      mach-nix
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
      pkg-config
      # pgcli
      pup
      robo3t
      termdown
      tmpmail
      up
      (gl_wrap pkgs { bin = "zeal"; })
      zathura
      zotero
      zip
    ];

    stateVersion = "20.09";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsNativeComp.override {
      imagemagick = pkgs.imagemagick;
    };
    extraPackages = (epkgs:
    [
      epkgs.vterm
      epkgs.pdf-tools
    ]);
  };

}
