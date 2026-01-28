{
  description = "NixOS configurations (multi-host)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      stylix,
      ...
    }:
    let
      system = "x86_64-linux";
      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      hostDirs = builtins.readDir ./hosts;
      hostNames = builtins.filter (name: name != "common" && hostDirs.${name} == "directory") (
        builtins.attrNames hostDirs
      );

      mkModules =
        name:
        let
          hostPath = builtins.toPath "${toString ./.}/hosts/${name}";
          baseModules = [
            "${hostPath}/configuration.nix"
            { networking.hostName = nixpkgs.lib.mkDefault name; }
            home-manager.nixosModules.home-manager
            {
              nixpkgs.hostPlatform = system;
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit unstablePkgs stylix; };
            }
          ];
          hardwareModules =
            if name == "p52" then [ nixos-hardware.nixosModules.lenovo-thinkpad-p52 ] else [ ];
        in
        hardwareModules ++ baseModules;

      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = mkModules name;
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkHost;
    };
}
