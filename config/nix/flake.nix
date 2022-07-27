{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixGL = { url = "github:guibou/nixGL/main"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      ref = "1a6ceb2d7500c3ff93a0385148d0f1f6a53222c0";
    };

    mach-nix = {
      type = "github";
      owner = "DavHau";
      repo = "mach-nix";
      ref = "51caf584f26acdfaa51bbf7ee1ffa365aea7bc64";
    };
  };

  outputs = { self, ... }@inputs:
    let
      mkHomeConfig = (import ./lib inputs).mkHomeConfig;
      overlays = [
        inputs.emacs.overlay
        (self: super: {
          nixGLIntel =
            (super.callPackage "${inputs.nixGL}/nixGL.nix" { }).nixGLIntel;

          mach-nix = inputs.mach-nix.packages.x86_64-linux.mach-nix;
        })
      ];
    in {
      homeConfigurations = {
        porcupine = mkHomeConfig "porcupine" ./hosts/porcupine.nix overlays;
      };

      porcupine = self.homeConfigurations.porcupine.activationPackage;
    };
}
