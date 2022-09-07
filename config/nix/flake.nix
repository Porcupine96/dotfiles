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
      ref = "30a3d95bb4d9812e26822260b6ac45efde0d7700";
    };

    mach-nix = {
      type = "github";
      owner = "DavHau";
      repo = "mach-nix";
      ref = "f15ea8677df951cb4fe608945fd98725dcd033b3";
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
