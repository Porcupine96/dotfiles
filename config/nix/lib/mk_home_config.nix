{ home-manager, hyprland, nixpkgs, ... }@inputs:

username: entrypoint: overlays:

home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.x86_64-linux;

  modules = [
    hyprland.homeManagerModules.default
    {wayland.windowManager.hyprland.enable = true;}
    {
      nixpkgs.overlays = overlays
        ++ [ (self: super: { gl_wrap = import ./gl_wrap.nix { }; }) ];
      imports = [ ../home.nix entrypoint ];
    }
    {
      home = {
        username = "porcupine";
        homeDirectory = "/home/porcupine";
      };
    }
  ];
}
