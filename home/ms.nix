{pkgs, ...}: {
  home.username = "ms";
  home.homeDirectory = "/home/ms";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    thunderbird
    gnumake
    google-chrome
    jetbrains.idea
    freecad
    kubectl
    k9s
    guake
    go
    gotools
    gcc
    gh
    xorg.xinput
    xorg.setxkbmap
    alejandra
  ];
  # does not fucking work
  #  home.sessionVariables = {
  #    GOPATH = "$HOME/go";
  #    GOBIN = "$HOME/go/bin";
  #    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  #  };
  #
  #  home.sessionPath = [
  #    "$HOME/go/bin"
  #  ];

  xdg.enable = true;

  xdg.configFile."autostart/guake.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Guake Terminal
    Exec=${pkgs.guake}/bin/guake
    X-GNOME-Autostart-enabled=true
    Comment=Start Guake on login
  '';
}
