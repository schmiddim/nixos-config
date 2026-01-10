{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./zsh.nix
    ./alacritty.nix
    ./sway.nix
    ./stylix.nix
    ./kanshi.nix
    ./waybar.nix

  ];
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    thunderbird
    google-chrome
    jetbrains.idea
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
    rofi
    imagemagick
    file
    pavucontrol # audio settings
    teams-for-linux
    signal-desktop
    nodejs
    wdisplays # screen management for wayland
    cliphist
    ripgrep
    codex
  ];

  home.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.sessionVariables.GOPATH}/bin";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";

  };

  home.file.".local/scripts/bin".source = ./shell-scripts;
  home.sessionPath = [
    "${config.home.sessionVariables.GOBIN}"
    "${config.home.homeDirectory}/bin"
    "${config.home.homeDirectory}/.local/scripts/bin"
  ];

  programs = {

    #  https://nixos.wiki/wiki/Neovim
    neovim = {
      enable = true;
      extraConfig = ''
        set number relativenumber
      '';
    };
  };

  # clipboard history
  services = {
    cliphist = {
      enable = true;
      allowImages = true;
      systemdTargets = [ "sway-session.target" ];
      extraOptions = [
        "-max-items"
        "2000"
        "-max-dedupe-search"
        "50"
      ];
    };
  };
}
