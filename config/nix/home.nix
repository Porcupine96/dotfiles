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
    ];

    stateVersion = "20.09";
  };
}
