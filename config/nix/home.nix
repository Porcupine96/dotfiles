{ pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      # Linux Tools
      flameshot
      fzf
      neofetch
      imv
      picom
      rofi
      tmux

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

      # JS
      yarn

      # Python
      mypy
      # TODO: mypy-protobuf

      # other
      (gl_wrap pkgs {
        bin = "anki";
        package = anki-bin;
      })
      # freetube <- issue with audio
      # ferdi <- issue with audio
      copyq
      ngrok
      (gl_wrap pkgs {
        bin = "obs";
        package = obs-studio;
      })
      ocrmypdf
      pandoc
      pdftk
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
