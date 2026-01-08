# Sway Shortcuts

Datum: 2026-01-08
Quelle: home/sway.nix (wayland.windowManager.sway.config.keybindings)
Modifikator: Mod4 (Super/Windows)

| Shortcut | Aktion | Erklaerung |
| --- | --- | --- |
| Mod4+Shift+c | reload | Laedt die Sway-Konfiguration neu. |
| Mod4+Shift+e | exec 'swaymsg exit' | Beendet die Sway-Session sauber. |
| Mod4+Shift+s | exec slurp \| grim -g - - \| wl-copy | Bereich auswaehlen, Screenshot erstellen und in die Zwischenablage kopieren. |
| Mod4+d | exec wofi --show drun | App-Launcher (Desktop-Run) oeffnen. |
| Mod4+q | kill | Aktives Fenster schliessen. |
| Mod4+Return | exec alacritty | Terminal oeffnen (alacritty). |
| Ctrl+Shift+l | exec systemctl suspend | System in den Suspend schicken. |
| Mod4+Shift+v | exec rofi -modi clipboard:$HOME/.local/scripts/bin/cliphist-rofi-img.sh -show clipboard -show-icons | Clipboard-Manager ueber rofi mit Icons oeffnen. |
| Mod4+h | splith | Horizontale Aufteilung fuer neue Container. |
| Mod4+v | splitv | Vertikale Aufteilung fuer neue Container. |
| Mod4+Up | focus up | Fokus nach oben bewegen. |
| Mod4+Left | focus left | Fokus nach links bewegen. |
| Mod4+Right | focus right | Fokus nach rechts bewegen. |
| Mod4+Down | focus down | Fokus nach unten bewegen. |
| Mod4+Shift+Left | move left | Fenster nach links verschieben. |
| Mod4+Shift+Down | move down | Fenster nach unten verschieben. |
| Mod4+Shift+Up | move up | Fenster nach oben verschieben. |
| Mod4+Shift+Right | move right | Fenster nach rechts verschieben. |
| Mod4+s | layout stacking | Layout auf Stacking setzen. |
| Mod4+w | layout tabbed | Layout auf Tabs setzen. |
| Mod4+e | layout toggle split | Zwischen Split-Layouts umschalten. |
| Mod4+r | mode resize | Resize-Modus aktivieren. |
| Mod4+1 | workspace number 1 | Zu Workspace 1 wechseln. |
| Mod4+2 | workspace number 2 | Zu Workspace 2 wechseln. |
| Mod4+3 | workspace number 3 | Zu Workspace 3 wechseln. |
| Mod4+4 | workspace number 4 | Zu Workspace 4 wechseln. |
| Mod4+5 | workspace number 5 | Zu Workspace 5 wechseln. |
| Mod4+6 | workspace number 6 | Zu Workspace 6 wechseln. |
| Mod4+7 | workspace number 7 | Zu Workspace 7 wechseln. |
| Mod4+8 | workspace number 8 | Zu Workspace 8 wechseln. |
| Mod4+9 | workspace number 9 | Zu Workspace 9 wechseln. |
| Mod4+0 | workspace number 10 | Zu Workspace 10 wechseln. |
| Mod4+Shift+1 | move container to workspace number 1 | Fenster nach Workspace 1 verschieben. |
| Mod4+Shift+2 | move container to workspace number 2 | Fenster nach Workspace 2 verschieben. |
| Mod4+Shift+3 | move container to workspace number 3 | Fenster nach Workspace 3 verschieben. |
| Mod4+Shift+4 | move container to workspace number 4 | Fenster nach Workspace 4 verschieben. |
| Mod4+Shift+5 | move container to workspace number 5 | Fenster nach Workspace 5 verschieben. |
| Mod4+Shift+6 | move container to workspace number 6 | Fenster nach Workspace 6 verschieben. |
| Mod4+Shift+7 | move container to workspace number 7 | Fenster nach Workspace 7 verschieben. |
| Mod4+Shift+8 | move container to workspace number 8 | Fenster nach Workspace 8 verschieben. |
| Mod4+Shift+9 | move container to workspace number 9 | Fenster nach Workspace 9 verschieben. |
| Mod4+Shift+0 | move container to workspace number 10 | Fenster nach Workspace 10 verschieben. |
| Mod4+Shift+l | exec swaylock -f -c 000000 | Bildschirm sperren (schwarz). |
| Mod4+n | exec sh -lc '.local/scripts/bin/sway-split-notion-gpt.sh >> /tmp/sway-split-notion-gpt.log 2>&1' | Startet ein Script fuer Split-Workspace und loggt nach /tmp. |
| XF86AudioRaiseVolume | exec sh -c 'wpctl status ... \| xargs ... wpctl set-volume {} 5%+' | Erhoeht die Lautstaerke aller erkannten Sinks um 5 Prozent. |
| XF86AudioLowerVolume | exec sh -c 'wpctl status ... \| xargs ... wpctl set-volume {} 5%-' | Verringert die Lautstaerke aller erkannten Sinks um 5 Prozent. |
| XF86AudioMute | exec sh -c 'wpctl status ... \| xargs ... wpctl set-mute {} toggle' | Schaltet Mute fuer alle erkannten Sinks um. |
