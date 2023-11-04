{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixGL = { url = "github:guibou/nixGL/main"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    emacs = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
      ref = "b7ce6bbf53b52f2059020ecf14127ffd1c375e90";
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
          # nixGLIntel =
          #   (super.callPackage "${inputs.nixGL}/nixGL.nix" { }).nixGLIntel;

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
