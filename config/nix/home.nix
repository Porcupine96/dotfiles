{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      cachix
      # Linux
      neofetch
      rofi

      # nix
      nixGLIntel
      nixfmt

      # other
      (gl_wrap pkgs { bin="anki"; package=anki-bin; })
    ];

    stateVersion = "20.09";
  };
}
