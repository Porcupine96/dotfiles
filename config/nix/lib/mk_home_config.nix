{ home-manager, ... }@inputs:

username: entrypoint: overlays:

home-manager.lib.homeManagerConfiguration {
  inherit username;
  homeDirectory = "/home/${username}";
  system = "x86_64-linux";
  configuration = { ... }: {
    nixpkgs.overlays = overlays;
    imports = [ ../home.nix entrypoint ];
  };
}
