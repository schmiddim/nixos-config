{ ... }:
{

  programs.waybar = {
    enable = true;

    settings = [
      {
        # "layer": "top",
        # "position": "bottom"
        height = 22;
        # "width": 1280,
        spacing = 4;

        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/scratchpad"
          "custom/media"
        ];

        modules-center = [
          "sway/window"
        ];

        modules-right = [
          #          "mpd"
          #          "idle_inhibitor"
          "pulseaudio"
          "network"
          "power-profiles-daemon"
          "cpu"
          "memory"
          #          "temperature"
          #          "backlight"
          #          "keyboard-state"
          #          "sway/language"
          "battery"
          #          "battery#bat2"
          "custom/weather"
          "clock"
          "tray"
          #          "custom/power"
        ];

        "sway/mode" = {
          format = "{}";
        };

        "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = [
            ""
            ""
          ];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };

        tray = {
          # "icon-size": 21,   # im Default auskommentiert
          spacing = 10;
          # icons = { ... }    # im Default auskommentiert
        };

        clock = {
          # "timezone": "America/New_York",  # im Default auskommentiert
          tooltip-format = "{:%Y %B}\n`{calendar}`";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };

        memory = {
          format = "{}% ";
        };

        battery = {
          states = {
            good = 95; # im Default auskommentiert
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰢜";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          # "format-good": "",  # auskommentiert
          # "format-full": "",  # auskommentiert (Alternative: hide)
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "custom/weather" = {
          format = "{icon} {text}";
          return-type = "json";
          interval = 900;
          exec = "$HOME/.local/scripts/bin/weather-waybar.sh";
          tooltip = true;
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        network = {
          # "interface": "wlp2*",  # im Default auskommentiert
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} 󰈀";
          tooltip-format = "{ifname} via {gwaddr} 󰈀";
          format-linked = "{ifname} (No IP) 󰈂";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click = "alacritty -e nmtui";
        };

        pulseaudio = {
          # "scroll-step": 1,  # im Default auskommentiert
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

        "custom/media" = {
          format = "{icon} {text}";
          return-type = "json";
          max-length = 40;
          format-icons = {
            spotify = "";
            default = "";
          };
          escape = true;
          exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null";
          # exec = "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null";
        };
      }
    ];
    style = ''
      /* wichtig: min-height auf 0, sonst erzwingen Module Minimums */
      * { min-height: 0; }

      /* NUR workspaces kompakter machen */
      #workspaces button {
        padding: 0px 6px;    /* vertikal 0 => deutlich niedriger */
        margin: 0px 1px;
        border-radius: 0px;  /* optional: falls radius Höhe „optisch“ erhöht */
      }

      /* falls active/hover extra padding bekommen: */
      #workspaces button.focused,
      #workspaces button.visible,
      #workspaces button.urgent {
        padding: 0px 6px;
      }

      /* optional, wenn Schrift zu groß ist */
      #workspaces * { font-size: 12px; }
    '';
  };

}
