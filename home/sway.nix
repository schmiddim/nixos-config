{ config, pkgs, ... }:

{
  # https://mynixos.com/options/wayland.windowManager.sway.config
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # fixes common GTK issues
    config = {
    # klappt nicht
      input = {
        "type:touchpad" = {
          events = "disabled";
        };
      };

      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        { command = "alacritty"; }
      ];
      bindswitches = {

      };
      keybindings = {

        "Mod4+Shift+c" = "reload";
        "Mod4+Shift+e" = "exec 'swaymsg exit'";
        "Mod4+d" = "exec wofi --show drun";
        "Mod4+e" = "exec pcmanfm";
        "Mod4+q" = "kill";

      };

    };
  };
}
