{ config, pkgs, ... }:

{
  # https://mynixos.com/options/wayland.windowManager.sway.config
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # fixes common GTK issues
    config =  {
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        { command = "alacritty"; }
      ];
      bindswitches = {


      };
      keybindings = {

        "${config.modifier}+Shift+c" = "reload";
        "${config.modifier}+Shift+e" = "exec 'swaymsg exit'";
        "${config.modifier}+d" = "exec wofi --show drun";
        "${config.modifier}+e" = "exec pcmanfm";
        "${config.modifier}+q" = "kill";

      };

    };
  };
}
