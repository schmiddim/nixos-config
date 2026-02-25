{
  config,
  pkgs,
  lib,
  unstablePkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./zsh.nix
    ./alacritty.nix
    ./sway.nix
    ./stylix.nix
    ./kanshi.nix
    ./waybar.nix
    ./mutt.nix

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
    curl
    jq
    neofetch
    alacritty
    librewolf
    pcmanfm
    nixd
    nixfmt-rfc-style
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    swayosd # modern volume/brightness overlay for Sway
    wofi
    rofi
    imagemagick
    file
    pavucontrol # audio settings
    signal-desktop
    nodejs
    wdisplays # screen management for wayland
    cliphist
    ripgrep
    libnotify
    codex
    wev
    wtype
    mplayer
    mpv
    killall
    xkill
    speedcrunch
    unstablePkgs.opencode # aktuellste Version aus nixpkgs-unstable
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs # Screen capture für wlroots/Sway
        obs-pipewire-audio-capture # Audio via PipeWire
      ];
    })
    # Modern CLI tools
    fzf # fuzzy finder
    bat # better cat with syntax highlighting
    eza # modern ls replacement
    fd # faster find

  ];

  home.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.sessionVariables.GOPATH}/bin";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    NIXOS_OZONE_WL = "1"; # run Chromium/Chrome on Wayland for smoother input + wtype support

  };

  home.file.".local/scripts/bin".source = ./shell-scripts;
  home.sessionPath = [
    "${config.home.sessionVariables.GOBIN}"
    "${config.home.homeDirectory}/bin"
    "${config.home.homeDirectory}/.local/scripts/bin"
  ];

  # Desktop-Einträge für Präsentation (erscheinen in Wofi/Rofi)
  # https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.desktopEntries
  xdg.desktopEntries.start-presentation = {
    name = "🎬 Start Presentation";
    comment = "Öffnet Presentation im Browser (Server im Hintergrund)";
    exec = "${config.home.homeDirectory}/.local/scripts/bin/start-presentation.sh";
    terminal = false;
    type = "Application";
    categories = [ "Utility" ];
  };

  xdg.desktopEntries.stop-presentation = {
    name = "⏹️ Stop Presentation";
    comment = "Stoppt den Präsentations-Server";
    exec = "${config.home.homeDirectory}/.local/scripts/bin/stop-presentation.sh";
    terminal = false;
    type = "Application";
    categories = [ "Utility" ];
  };
    xdg.desktopEntries.port-forward = {
      name = "port forward";
      comment = "forward the port";
      exec = "${config.home.homeDirectory}/.local/scripts/bin/k8s-port-forward.sh";
      terminal = false;
      type = "Application";
      categories = [ "Utility" ];
    };

  xdg.desktopEntries.presentation-environment = {
    name = "💻 Presentation Environment";
    comment = "Öffnet 2 Terminals (k9s + shell) in ~/code/teapot-operator mit IntelliJ im Hintergrund";
    exec = "${config.home.homeDirectory}/.local/scripts/bin/sway-presentation-environment.sh";
    terminal = false;
    type = "Application";
    categories = [ "Development" ];
  };

  programs = {

    #  https://nixos.wiki/wiki/Neovim
    neovim = {
      enable = true;
      extraConfig = ''
        set number relativenumber
      '';
    };

    # Auto-load environment per directory
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Fuzzy finder integration
    fzf = {
      enable = true;
      enableZshIntegration = true;
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

  systemd.user.services.battery-notify = {
    Unit = {
      Description = "Battery low notification";
      PartOf = [ "sway-session.target" ];
      After = [ "sway-session.target" ];
    };
    Service = {
      ExecStart = "${config.home.homeDirectory}/.local/scripts/bin/battery-notify.sh";
      Environment = "PATH=${
        lib.makeBinPath [
          pkgs.bash
          pkgs.coreutils
          pkgs.gawk
          pkgs.ripgrep
          pkgs.upower
          pkgs.libnotify
        ]
      }";
      Restart = "always";
      RestartSec = 10;
    };
    Install = {
      WantedBy = [ "sway-session.target" ];
    };
  };
}
