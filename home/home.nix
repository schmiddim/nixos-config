{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
  ];
  home.stateVersion = "25.11";

  # Beispiel: weitere HM Pakete (optional)
  home.packages = with pkgs; [
    go
    gotools
    gh
    kubectl
    k9s
    gcc
    wget

    alacritty
    firefox
    pcmanfm
    nixd
    nixfmt-rfc-style
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
  ];
  home.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.sessionVariables.GOPATH}/bin";
#    PATH = "$GOBIN:$PATH";

  };
  home.sessionPath =[
    "${config.home.sessionVariables.GOBIN}"
    "${config.home.homeDirectory}/bin"
  ];

}
