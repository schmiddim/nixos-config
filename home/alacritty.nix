{ config, pkgs, ... }:
{

  programs.alacritty = {
    enable = true;
    theme = "dracula";   # Beispiel-Theme
    settings = {
      font = {
        normal = {
          family = "JetBrains Mono"; # oder ein anderer Font
        };
        size = 16.0; # Schriftgröße, z. B. 16
      };
    };
  };

}
