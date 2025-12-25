{ config, pkgs, ... }:
{
/*
https://mynixos.com/options/programs.alacritty
*/
  programs.alacritty = {
    enable = true;
    theme = "dracula";   # Beispiel-Theme
    settings = {
      font = {
#        normal = {
#          family = "JetBrains Mono"; # oder ein anderer Font
#        };
        size = 11.0;
      };
    };
  };

}
