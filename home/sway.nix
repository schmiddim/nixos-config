{ config, pkgs, ... }:

{
  wayland.systemd.target = "sway-session.target";
  # https://mynixos.com/options/wayland.windowManager.sway.config
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;

    wrapperFeatures.gtk = true; # fixes common GTK issues
    extraConfig = ''
        set $ws1 "1:web"
        set $ws2 "2:code"
        set $ws3 "3:term"
        set $ws4 "4:files"

    '''
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
