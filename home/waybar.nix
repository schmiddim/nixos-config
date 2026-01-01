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
          "clock"
          "tray"
#          "custom/power"
        ];

        # Module configs (wie Default)
        #        "keyboard-state" = {
        #          numlock = true;
        #          capslock = true;
        #          format = "{name} {icon}";
        #          format-icons = {
        #            locked = "";
        #            unlocked = "";
        #          };
        #        };

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

        #        mpd = {
        #          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
        #          format-disconnected = "Disconnected ";
        #          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
        #          unknown-tag = "N/A";
        #          interval = 5;
        #          consume-icons = { on = " "; };
        #          random-icons = { off = " "; on = " "; };
        #          repeat-icons = { on = " "; };
        #          single-icons = { on = "1 "; };
        #          state-icons = { paused = ""; playing = ""; };
        #          tooltip-format = "MPD (connected)";
        #          tooltip-format-disconnected = "MPD (disconnected)";
        #        };

#        idle_inhibitor = {
#          format = "{icon}";
#          format-icons = {
#            activated = "";
#            deactivated = "";
#          };
#        };

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

        #        temperature = {
        #          # "thermal-zone": 2,                   # im Default auskommentiert
        #          # "hwmon-path": "/sys/class/...",      # im Default auskommentiert
        #          critical-threshold = 80;
        #          # "format-critical": "{temperatureC}°C {icon}",  # auskommentiert
        #          format = "{temperatureC}°C {icon}";
        #          format-icons = [ "" "" "" ];
        #        };

        #        backlight = {
        #          # "device": "acpi_video1",  # im Default auskommentiert
        #          format = "{percent}% {icon}";
        #          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        #        };

        battery = {
          states = {
            good = 95; # im Default auskommentiert
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
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

#        "battery#bat2" = {
#          bat = "BAT2";
#        };

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

#        "custom/power" = {
#          format = "⏻ ";
#          tooltip = false;
#          menu = "on-click";
#          menu-file = "$HOME/.config/waybar/power_menu.xml";
#          menu-actions = {
#            shutdown = "shutdown";
#            reboot = "reboot";
#            suspend = "systemctl suspend";
#            hibernate = "systemctl hibernate";
#          };
#        };
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
