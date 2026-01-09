{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    localVariables = {
      CASE_SENSITIVE = "true";
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      edit = "sudo -e";
      update = "sudo nixos-rebuild switch";
      screenshot = "slurp | grim -g - - | wl-copy";
      sl3 = "sleep 3 && swaylock -f && systemctl suspend";

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
      plugins = [
        "git"
        "sudo"
      ];
    };

    envExtra = ''
      local secrets_file="$HOME/.config/zsh/env.secrets"
      [[ -f "$secrets_file" ]] && source "$secrets_file"
    '';

    initContent = ''
      PROMPT="%F{blue}%n@%m%f %F{yellow}%~%f %# "
    '';
  };
}
