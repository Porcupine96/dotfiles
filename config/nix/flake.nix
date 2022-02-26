{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixGL = {
        url = "github:guibou/nixGL/main";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs:
    let
      mkHomeConfig = (import ./lib inputs).mkHomeConfig;
      overlays = [
        (self: super: {
          nixGLIntel  = (super.callPackage "${inputs.nixGL}/nixGL.nix" { }).nixGLIntel;
        })
      ];
    in {
      homeConfigurations = {
        porcupine = mkHomeConfig "porcupine" ./hosts/porcupine.nix overlays;
      };

      porcupine = self.homeConfigurations.porcupine.activationPackage;
    };
}
