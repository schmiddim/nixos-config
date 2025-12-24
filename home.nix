{ config, pkgs, ... }:

{
  home-manager.users.ms = {
    home.stateVersion = "25.11";

    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # fixes common GTK issues
      config = rec {
        modifier = "Mod4";
        terminal = "kitty";
        startup = [
          { command = "firefox"; }
        ];
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        edit = "sudo -e";
        update = "sudo nixos-rebuild switch";
      };

      history = {
        size = 10000;
        ignoreAllDups = true;
        path = "$HOME/.zsh_history";
        ignorePatterns = [
          "rm *"
          "pkill *"
          "cp *"
        ];
      };

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "sudo" ];
      };

      # shell = pkgs.zsh;
    };

    # Beispiel: weitere HM Pakete (optional)
    home.packages = with pkgs; [
     kitty
     firefox

     ];
  };
}