{ config, pkgs, ... }:
let
  wp = builtins.path { path = /run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png; name = "wallpaper.png"; };
in
{
  wayland.systemd.target = "sway-session.target";
  # https://mynixos.com/options/wayland.windowManager.sway.config
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;

    wrapperFeatures.gtk = true; # fixes common GTK issues
    extraConfig = ''

    '';
    config = {
      input = {
        "type:touchpad" = {
          events = "disabled";
        };
      };
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
#        "Mod4+e" = "exec pcmanfm";
        "Mod4+q" = "kill";
        "Mod4+Return" = "exec alacritty";

        ############################
        # Split horizontal, vertical
        "Mod4+h"= "splith";
        "Mod4+v"= "splitv";
        ############################
        # focus
        ############################
        "Mod4+Up"= "focus up";
        "Mod4+Left"= "focus left";
        "Mod4+Right"= "focus right";
        "Mod4+Down"= "focus down";
        ############################
        # Layout
        ############################
        "Mod4+s"= "layout stacking";
        "Mod4+w"= "layout tabbed";
        "Mod4+e"= "layout toggle split";
        "Mod4+r" = "mode resize";





        ############################
        # Workspaces
        ############################
        "Mod4+1"= "workspace number 1";
        "Mod4+2"= "workspace number 2";
        "Mod4+3"= "workspace number 3";
        "Mod4+4"= "workspace number 4";
        "Mod4+5"= "workspace number 5";
        "Mod4+6"= "workspace number 6";
        "Mod4+7"= "workspace number 7";
        "Mod4+8"= "workspace number 8";
        "Mod4+9"= "workspace number 9";
        "Mod4+0"= "workspace number 10";
        ############################
        # Switch to Workspaces
        ############################
        "Mod4+Shift+1"= "move container to workspace number 1";
        "Mod4+Shift+2"= "move container to workspace number 2";
        "Mod4+Shift+3"= "move container to workspace number 3";
        "Mod4+Shift+4"= "move container to workspace number 4";
        "Mod4+Shift+5"= "move container to workspace number 5";
        "Mod4+Shift+6"= "move container to workspace number 6";
        "Mod4+Shift+7"= "move container to workspace number 7";
        "Mod4+Shift+8"= "move container to workspace number 8";
        "Mod4+Shift+9"= "move container to workspace number 9";
        "Mod4+Shift+0"= "move container to workspace number 10";


#        ############################
        # Lock Screen
        ############################
        "Mod4+Shift+l" = "exec swaylock -f -c 000000";

        ## Web screen Opens a new Workspace and displays 2 web pages in split
        "Mod4+n" =
          "exec sh -lc '.local/scripts/bin/sway-split-notion-gpt.sh  >> /tmp/sway-split-notion-gpt.log 2>&1'";

      };
      output = {
        "*" = {
          "bg" = "${wp} fill";
        };
      };
    };
  };
}
