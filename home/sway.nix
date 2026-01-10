{ pkgs, ... }:
let
  mod = "Mod4";
  wtype = "${pkgs.wtype}/bin/wtype";
in
{
  wayland.systemd.target = "sway-session.target";
  # https://mynixos.com/options/wayland.windowManager.sway.config
  wayland.windowManager.sway = {
    enable = true;
    extraOptions = [
      "--unsupported-gpu" # Dockingstation...
    ];
    wrapperFeatures.gtk = true; # fixes common GTK issues
    extraConfig = ''
      # focus
      client.focused          #5e81ac #5e81ac #ffffff #5e81ac #5e81ac
      client.focused_inactive #3b4252 #3b4252 #d8dee9 #3b4252 #3b4252
      client.unfocused        #2e3440 #2e3440 #888888 #2e3440 #2e3440
      client.urgent           #bf616a #bf616a #ffffff #bf616a #bf616a

      # keep pointer visible (TrackPoint + DisplayLink sometimes lose hardware cursor)
      # Wenn der Cursor trotzdem weg ist, bitte swaymsg -t get_inputs und swaymsg -t get_outputs schicken; dann können wir eine gerätespezifische Input-Section ergänzen.
      seat seat0 hide_cursor 0
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
        "type:keyboard" = {
          xkb_numlock = "enabled";
          xkb_layout = "us"; # keep plain US; umlauts are injected via Mod5 bindings below
          xkb_options = "lv3:ralt_switch"; # make Right Alt a level3 switch (Mod5)
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
        "${mod}+Shift+s" = "exec slurp | grim -g - - | wl-copy"; # screenshots
        "${mod}+d" = "exec wofi --show drun";
        "${mod}+q" = "kill";
        "${mod}+Return" = "exec alacritty";
        "Ctrl+Shift+l" = "exec systemctl suspend";
        "${mod}+Shift+v" =
          "exec  rofi -modi clipboard:$HOME/.local/scripts/bin/cliphist-rofi-img.sh -show clipboard -show-icons";

        #############################
        # Split horizontal, vertical
        "${mod}+h" = "splith";
        "${mod}+v" = "splitv";
        #############################
        # focus
        #############################
        "${mod}+Up" = "focus up";
        "${mod}+Left" = "focus left";
        "${mod}+Right" = "focus right";
        "${mod}+Down" = "focus down";

        # Move windows
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        #############################
        # Layout
        #############################
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+r" = "mode resize";

        #############################
        # Workspaces
        #############################
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
        #############################
        # Switch to Workspaces
        #############################
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

        #############################
        # Lock Screen
        #############################
        "${mod}+Shift+l" = "exec swaylock -f -c 000000";

        ## Web screen Opens a new Workspace and displays 2 web pages in split
        "${mod}+n" =
          "exec sh -lc '.local/scripts/bin/sway-split-notion-gpt.sh  >> /tmp/sway-split-notion-gpt.log 2>&1'";

        #############################
        # Thinkpad Special Keys
        #############################
        # Audio
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";

        # Brightness
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";

        # Display switch (Fn+F8)
        "XF86Display" = "exec wdisplays";
        "XF86Switch_VT_1" = "exec wdisplays";
        "XF86Switch_VT_2" = "exec wdisplays";

        #############################
        # Umlauts
        #############################
        # AltGr bindings for umlauts while keeping US layout
        "Mod5+semicolon" = "exec ${wtype} ö";
        "Mod5+Shift+semicolon" = "exec ${wtype} Ö";
        "Mod5+apostrophe" = "exec ${wtype} ä";
        "Mod5+Shift+apostrophe" = "exec ${wtype} Ä";
        "Mod5+bracketleft" = "exec ${wtype} ü";
        "Mod5+Shift+bracketleft" = "exec ${wtype} Ü";
        "Mod5+minus" = "exec ${wtype} ß";
        "Mod5+Shift+minus" = "exec ${wtype} ẞ";
      };
    };
  };
}
