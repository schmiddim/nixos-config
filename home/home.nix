{ config, pkgs, ... }:


let
  swayScripts = import ./shell-scripts/sway-split.nix { inherit pkgs; };
in
{
  imports = [
    ./zsh.nix
    ./alacritty.nix
    ./sway.nix

  ];
  home.stateVersion = "25.11";

  # Beispiel: weitere HM Pakete (optional)
  home.packages = with pkgs; [
    thunderbird
    google-chrome
    jetbrains.idea-ultimate
    freecad
    gimp
    go
    gotools
    gh
    kubectl
    k9s
    gcc
    wget
    jq

    neofetch
    alacritty
    firefox
    pcmanfm
    nixd
    nixfmt-rfc-style
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    wofi
  ];
  home.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.sessionVariables.GOPATH}/bin";
    #    PATH = "$GOBIN:$PATH";

  };
  home.sessionPath = [
    "${config.home.sessionVariables.GOBIN}"
    "${config.home.homeDirectory}/bin"
  ];

}
