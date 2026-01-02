{
  description = "NixOS configuration for ThinkPad P52";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.p52 = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-p52
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          nixpkgs.hostPlatform = system;
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
