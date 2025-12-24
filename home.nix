{
  home-manager.users.ms = {
    home.stateVersion = "25.11";
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

      history.size = 10000;
      history.ignoreAllDups = true;
      history.path = "$HOME/.zsh_history";
      history.ignorePatterns = [
        "rm *"
        "pkill *"
        "cp *"
      ];

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "sudo"
        ];

      };
      #    shell = pkgs.zsh;
    };
    # Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];
  };

}
