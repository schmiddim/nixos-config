{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./zsh.nix
    ./alacritty.nix
    ./sway.nix
    ./stylix.nix

  ];
  home.stateVersion = "25.11";

  # Beispiel: weitere HM Pakete (optional)
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
    pavucontrol # audio settings
    signal-desktop
    nodejs
    wdisplays # screen management for wayland
    cliphist
    ripgrep
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
    # https://github.com/Alexays/Waybar/blob/master/resources/config.jsonc
    # https://mynixos.com/home-manager/option/programs.waybar.settings
    waybar = {
      enable = true;
    };

    #  https://nixos.wiki/wiki/Neovim
    neovim = {
      enable = true;
      extraConfig = ''
        set number relativenumber
      '';
    };
  };
}
