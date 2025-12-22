{pkgs, ...}: {
  home.username = "ms";
  home.homeDirectory = "/home/ms";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    thunderbird
    gnumake
    vim
    wget
    google-chrome
    jetbrains.idea # -ultimate
    freecad
    kubectl
    k9s
    htop
    git
    guake
    go
    gotools
    gcc
    usbutils
    gh
    xorg.xinput
    xorg.setxkbmap
    alejandra
  ];
}
