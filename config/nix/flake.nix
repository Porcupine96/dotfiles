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
  };

  outputs = { self, ... }@inputs:
    let
      mkHomeConfig = (import ./lib inputs).mkHomeConfig;
      overlays = [
        inputs.emacs.overlay
        (self: super: {
          nixGLIntel =
            (super.callPackage "${inputs.nixGL}/nixGL.nix" { }).nixGLIntel;
        })
      ];
    in {
      homeConfigurations = {
        porcupine = mkHomeConfig "porcupine" ./hosts/porcupine.nix overlays;
      };

      porcupine = self.homeConfigurations.porcupine.activationPackage;
    };
}
