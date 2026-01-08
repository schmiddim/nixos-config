# Sway Shortcuts

Datum: 2026-01-08

Mod = Mod4 (Super/Windows)

| Shortcut | Action |
| --- | --- |
| `Mod+Shift+c` | `reload` |
| `Mod+Shift+e` | `exec swaymsg exit` |
| `Mod+Shift+s` | `exec slurp | grim -g - - | wl-copy` (screenshot) |
| `Mod+d` | `exec wofi --show drun` |
| `Mod+q` | `kill` |
| `Mod+Return` | `exec alacritty` |
| `Ctrl+Shift+l` | `exec systemctl suspend` |
| `Mod+Shift+v` | `exec rofi -modi clipboard:$HOME/.local/scripts/bin/cliphist-rofi-img.sh -show clipboard -show-icons` |
| `Mod+h` | `splith` |
| `Mod+v` | `splitv` |
| `Mod+Up` | `focus up` |
| `Mod+Left` | `focus left` |
| `Mod+Right` | `focus right` |
| `Mod+Down` | `focus down` |
| `Mod+Shift+Left` | `move left` |
| `Mod+Shift+Down` | `move down` |
| `Mod+Shift+Up` | `move up` |
| `Mod+Shift+Right` | `move right` |
| `Mod+s` | `layout stacking` |
| `Mod+w` | `layout tabbed` |
| `Mod+e` | `layout toggle split` |
| `Mod+r` | `mode resize` |
| `Mod+1` | `workspace number 1` |
| `Mod+2` | `workspace number 2` |
| `Mod+3` | `workspace number 3` |
| `Mod+4` | `workspace number 4` |
| `Mod+5` | `workspace number 5` |
| `Mod+6` | `workspace number 6` |
| `Mod+7` | `workspace number 7` |
| `Mod+8` | `workspace number 8` |
| `Mod+9` | `workspace number 9` |
| `Mod+0` | `workspace number 10` |
| `Mod+Shift+1` | `move container to workspace number 1` |
| `Mod+Shift+2` | `move container to workspace number 2` |
| `Mod+Shift+3` | `move container to workspace number 3` |
| `Mod+Shift+4` | `move container to workspace number 4` |
| `Mod+Shift+5` | `move container to workspace number 5` |
| `Mod+Shift+6` | `move container to workspace number 6` |
| `Mod+Shift+7` | `move container to workspace number 7` |
| `Mod+Shift+8` | `move container to workspace number 8` |
| `Mod+Shift+9` | `move container to workspace number 9` |
| `Mod+Shift+0` | `move container to workspace number 10` |
| `Mod+Shift+l` | `exec swaylock -f -c 000000` |
| `Mod+n` | `exec sh -lc '.local/scripts/bin/sway-split-notion-gpt.sh >> /tmp/sway-split-notion-gpt.log 2>&1'` |
| `XF86AudioRaiseVolume` | `exec sh -c 'wpctl status | awk "/Sinks:/{f=1;next} /Sources:/{f=0} f && /^[[:space:]]+[0-9]+\\./{gsub(\\"\\.\\",\\"\\",$1); print $1}" | xargs -n1 -I{} wpctl set-volume {} 5%+'` |
| `XF86AudioLowerVolume` | `exec sh -c 'wpctl status | awk "/Sinks:/{f=1;next} /Sources:/{f=0} f && /^[[:space:]]+[0-9]+\\./{gsub(\\"\\.\\",\\"\\",$1); print $1}" | xargs -n1 -I{} wpctl set-volume {} 5%-'` |
| `XF86AudioMute` | `exec sh -c 'wpctl status | awk "/Sinks:/{f=1;next} /Sources:/{f=0} f && /^[[:space:]]+[0-9]+\\./{gsub(\\"\\.\\",\\"\\",$1); print $1}" | xargs -n1 -I{} wpctl set-mute {} toggle'` |
