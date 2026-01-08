# Sway Shortcuts

Mod4 entspricht der Super/Windows-Taste.

## Allgemein

| Shortcut | Aktion | Hinweis |
| --- | --- | --- |
| Mod+Shift+c | Konfiguration neu laden | `reload` |
| Mod+Shift+e | Sway beenden | `swaymsg exit` |
| Mod+Shift+s | Screenshot in die Zwischenablage | `slurp | grim -g - - | wl-copy` |
| Mod+d | App-Launcher | `wofi --show drun` |
| Mod+q | Fenster schließen | `kill` |
| Mod+Return | Terminal öffnen | `alacritty` |
| Ctrl+Shift+l | System suspendieren | `systemctl suspend` |
| Mod+Shift+v | Clipboard-Launcher | `rofi` + `cliphist` |
| Mod+Shift+l | Screen lock | `swaylock -f -c 000000` |
| Mod+n | Notion + ChatGPT Split-Workspace | Script `sway-split-notion-gpt.sh` |

## Split & Layout

| Shortcut | Aktion | Hinweis |
| --- | --- | --- |
| Mod+h | Horizontal splitten | `splith` |
| Mod+v | Vertikal splitten | `splitv` |
| Mod+s | Layout: stacking | `layout stacking` |
| Mod+w | Layout: tabbed | `layout tabbed` |
| Mod+e | Layout: toggle split | `layout toggle split` |
| Mod+r | Resize-Mode | `mode resize` |

## Fokus

| Shortcut | Aktion | Hinweis |
| --- | --- | --- |
| Mod+Up | Fokus nach oben | `focus up` |
| Mod+Left | Fokus nach links | `focus left` |
| Mod+Right | Fokus nach rechts | `focus right` |
| Mod+Down | Fokus nach unten | `focus down` |

## Fenster verschieben

| Shortcut | Aktion | Hinweis |
| --- | --- | --- |
| Mod+Shift+Left | Fenster nach links | `move left` |
| Mod+Shift+Down | Fenster nach unten | `move down` |
| Mod+Shift+Up | Fenster nach oben | `move up` |
| Mod+Shift+Right | Fenster nach rechts | `move right` |

## Workspaces

| Shortcut | Aktion | Hinweis |
| --- | --- | --- |
| Mod+1 | Workspace 1 | `workspace number 1` |
| Mod+2 | Workspace 2 | `workspace number 2` |
| Mod+3 | Workspace 3 | `workspace number 3` |
| Mod+4 | Workspace 4 | `workspace number 4` |
| Mod+5 | Workspace 5 | `workspace number 5` |
| Mod+6 | Workspace 6 | `workspace number 6` |
| Mod+7 | Workspace 7 | `workspace number 7` |
| Mod+8 | Workspace 8 | `workspace number 8` |
| Mod+9 | Workspace 9 | `workspace number 9` |
| Mod+0 | Workspace 10 | `workspace number 10` |
| Mod+Shift+1 | Fenster nach Workspace 1 | `move container to workspace number 1` |
| Mod+Shift+2 | Fenster nach Workspace 2 | `move container to workspace number 2` |
| Mod+Shift+3 | Fenster nach Workspace 3 | `move container to workspace number 3` |
| Mod+Shift+4 | Fenster nach Workspace 4 | `move container to workspace number 4` |
| Mod+Shift+5 | Fenster nach Workspace 5 | `move container to workspace number 5` |
| Mod+Shift+6 | Fenster nach Workspace 6 | `move container to workspace number 6` |
| Mod+Shift+7 | Fenster nach Workspace 7 | `move container to workspace number 7` |
| Mod+Shift+8 | Fenster nach Workspace 8 | `move container to workspace number 8` |
| Mod+Shift+9 | Fenster nach Workspace 9 | `move container to workspace number 9` |
| Mod+Shift+0 | Fenster nach Workspace 10 | `move container to workspace number 10` |

## Audio

| Shortcut | Aktion | Hinweis |
| --- | --- | --- |
| XF86AudioRaiseVolume | Volume +5% | `wpctl set-volume ... 5%+` |
| XF86AudioLowerVolume | Volume -5% | `wpctl set-volume ... 5%-` |
| XF86AudioMute | Mute toggle | `wpctl set-mute ... toggle` |
