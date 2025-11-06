{ config, pkgs, ... }:
{
  /*
    https://mynixos.com/options/programs.alacritty

    interesting keybindings
    https://github.com/smravec/nixos-config/blob/main/home-manager/config/alacritty.nix
  */
  programs.alacritty = {
    enable = true;
    theme = "dracula"; # Beispiel-Theme
  };

}
