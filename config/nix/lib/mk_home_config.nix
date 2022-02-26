{ home-manager, ... }@inputs:

username: entrypoint: overlays:

home-manager.lib.homeManagerConfiguration {
  inherit username;
  homeDirectory = "/home/${username}";
  system = "x86_64-linux";
  configuration = { ... }: {
    nixpkgs.overlays = overlays ++ [
      (self: super: { gl_wrap = import ./gl_wrap.nix {}; })
    ];
    imports = [ ../home.nix entrypoint ];
  };
}
