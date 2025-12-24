{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
  ];
  home.stateVersion = "25.11";


  # Beispiel: weitere HM Pakete (optional)
  home.packages = with pkgs; [
    alacritty
    firefox
    pcmanfm
    nixd
    nixfmt-rfc-style
  ];

}
