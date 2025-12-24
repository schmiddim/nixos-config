{ config, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # fixes common GTK issues
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        { command = "firefox"; }
      ];
    };
  };
}