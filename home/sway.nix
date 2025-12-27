{ config, pkgs, ... }:

{
  wayland.systemd.target = "sway-session.target";
  # https://mynixos.com/options/wayland.windowManager.sway.config
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
#    wayland.systemd.target = "sway-session.target";

    wrapperFeatures.gtk = true; # fixes common GTK issues
    config = {
      input = {
        "type:touchpad" = {
          events = "disabled";
        };
      };
##!/usr/bin/env bash
#swaymsg -t subscribe '[ "output" ]' | while read -r _; do
#  swaymsg "output * dpms on"
#done

      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
#        { command = "alacritty"; }
        {
          command = ''
            swayidle -w \
                timeout 300 'swaylock -f' \
                timeout 600 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
                before-sleep 'swaylock -f'
          '';
        }
      ];
      bindswitches = {

      };
      keybindings = {

        "Mod4+Shift+c" = "reload";
        "Mod4+Shift+e" = "exec 'swaymsg exit'";
        "Mod4+d" = "exec wofi --show drun";
        "Mod4+e" = "exec pcmanfm";
        "Mod4+q" = "kill";

        ############################
        # Lock Screen
        ############################
        "Mod4+Shift+l" = "exec swaylock -f -c 000000";

        ## Web screen Opens a new Workspace and displays 2 web pages in split
        "Mod4+n" = "exec sh -lc 'sway-split-notion-gpt.sh  >> /tmpsway-split-notion-gpt.log 2>&1'";

      };

    };
  };
}
