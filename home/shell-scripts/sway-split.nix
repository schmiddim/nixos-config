{ pkgs }:

{
  web-setup = pkgs.writeShellScriptBin "web-setup" ''
    #!${pkgs.bash}/bin/bash
    WS="9:web"

    if swaymsg -t get_workspaces | ${pkgs.jq}/bin/jq -e '.[] | select(.name=="'"$WS"'")' >/dev/null 2>&1; then
      swaymsg workspace "$WS"
      exit 0
    fi

    swaymsg workspace "$WS"
    swaymsg split horizontal
    swaymsg exec 'chromium --new-window https://www.notion.so/'
    sleep 0.2
    swaymsg focus right
    swaymsg exec 'chromium --new-window https://chat.openai.com/'
  '';

  # Weitere Scripts hier hinzufügen
}
