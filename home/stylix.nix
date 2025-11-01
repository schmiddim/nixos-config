{ pkgs, ... }:

let
  stylixSrc = builtins.fetchTarball {
    url = "https://github.com/nix-community/stylix/archive/release-25.11.tar.gz";
    sha256 = "0lh4ah6k3l31ijap62bsi9258m7y542q2k3xrjlxi3nrr2yvbr6f";
  };
in
{
  imports = [
    (import stylixSrc).homeModules.stylix
  ];

  stylix = {
    enable = true;
    image = ./Sway_Wallpaper_Blue_1920x1080.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

    opacity = {
      desktop = 0.3; # Bars/Widgets (Waybar zählt hier rein)
      terminal = 0.9; # optional
      popups = 1.0; # optional
    };

    targets.waybar = {
      colors.enable = true;
      opacity.enable = true; # nutzt config.stylix.opacity
    };

  };
}
