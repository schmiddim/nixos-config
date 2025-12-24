{
  description = "Wayland-first NixOS configuration with Sway";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
    {
      nixosConfigurations.nixos-wayland = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs; };
        modules = [
          ./configuration.nix
        ];
      };

      formatter.${system} = pkgs.alejandra;
    };
}
