{ ... }:
let
  wp = builtins.path {
    path = /run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png;
    name = "wallpaper.png";
  };
  mod="Mod4";
in
{
  wayland.systemd.target = "sway-session.target";
  # https://mynixos.com/options/wayland.windowManager.sway.config
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # fixes common GTK issues
    extraConfig = ''
    '';
    config = {
      bars = [
        {
          command = "waybar";
        }
      ];

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

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec 'swaymsg exit'";
        "${mod}+d" = "exec wofi --show drun";
        #        "${mod}+e" = "exec pcmanfm";
        "${mod}+q" = "kill";
        "${mod}+Return" = "exec alacritty";

        ############################
        # Split horizontal, vertical
        "${mod}+h" = "splith";
        "${mod}+v" = "splitv";
        ############################
        # focus
        ############################
        "${mod}+Up" = "focus up";
        "${mod}+Left" = "focus left";
        "${mod}+Right" = "focus right";
        "${mod}+Down" = "focus down";
        ############################
        # Layout
        ############################
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+r" = "mode resize";

        ############################
        # Workspaces
        ############################
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";
        ############################
        # Switch to Workspaces
        ############################
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        #        ############################
        # Lock Screen
        ############################
        "${mod}+Shift+l" = "exec swaylock -f -c 000000";

        ## Web screen Opens a new Workspace and displays 2 web pages in split
        "${mod}+n" =
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
