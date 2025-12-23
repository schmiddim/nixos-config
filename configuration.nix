{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # --- Nix basics (flake-frei) ---
  nix.nixPath = [
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    settings.experimental-features = ["nix-command"];
  };

  # --- Boot / Kernel ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_6;
  boot.extraModulePackages = with config.boot.kernelPackages; [evdi];
  boot.initrd.kernelModules = ["evdi"];

boot.kernelModules = [ "psmouse" ];
boot.extraModprobeConfig = ''
  options psmouse proto=imps
'';

  boot.kernelParams = [
    "usbcore.autosuspend=-1"
    "ucsi.disable_pm=1"
  ];

  # --- Host / Time / Locale ---
  networking.hostName = "p52-nixos";
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;
    }
  ];
  boot.resumeDevice = "/swapfile";

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  boot.kernel.sysctl."vm.swappiness" = 10;
  networking.networkmanager.enable = true;

# --- Wayland / Sway ---


services.xserver.enable = false; # kein X11-Desktop mehr

# Polkit ist in der Praxis fast immer nötig (NetworkManager-Applets, Mounts, etc.)
security.polkit.enable = true;  # (wichtig für viele Desktop-Aktionen) :contentReference[oaicite:0]{index=0}

programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true;   # GTK-Apps bekommen die richtigen Env-Variablen :contentReference[oaicite:1]{index=1}
  extraPackages = with pkgs; [
    # Basics, damit du nicht "nackt" dastehst:
    swaylock swayidle
    waybar
    mako
    grim slurp
    wl-clipboard
    alacritty
    tdrop
  ];
};

# Login-Manager für Wayland: greetd + tuigreet (leichtgewichtig)
services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
      user = "greeter";
    };
  };
};


  # --- X11 / Desktop (Cinnamon + LightDM) ---
#  services.xserver.enable = true;
#  services.xserver.videoDrivers = ["displaylink" "modesetting"];
#
#  services.xserver.desktopManager.cinnamon.enable = true;
#  services.xserver.displayManager.lightdm.enable = true;
#
#  services.xserver.xkb = {
#    layout = "de";
#    variant = "";
#  };

  # Per-device keymap + touchpad disable (X11 session)
#  services.xserver.displayManager.sessionCommands = ''
#    id="$(xinput list | awk -F'id=' '/Keychron/ && /Keyboard/ && /slave  keyboard/ {print $2}' | awk '{print $1; exit}')"
#    if [ -n "$id" ]; then
#      setxkbmap -device "$id" -model pc105 -layout us
#    fi
#
#    tp_id="$(xinput list | awk -F'id=' '/Touchpad/ {print $2}' | awk '{print $1; exit}')"
#    if [ -n "$tp_id" ]; then
#      xinput disable "$tp_id"
#    fi
#  '';

  # --- Printing / mDNS ---
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [hplip];
  programs.system-config-printer.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # --- Audio (PipeWire) ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.nix-ld.enable = true; # intellij

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git" "sudo"];
    };
    interactiveShellInit = ''
      autoload -Uz compinit
      compinit
      zstyle ':completion:*:-command-:*' tag-order '!parameters'
    '';
  };

  # --- User ---
  users.users.ms = {
    isNormalUser = true;
    description = "ms";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel"];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    git
    gnumake
    gcc
    usbutils
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
    guake
    xorg.xinput
    xorg.setxkbmap
    alejandra
    nh
wofi 
alacritty
    # Basics, damit du nicht "nackt" dastehst:
    swaylock swayidle
    waybar
    mako
    grim slurp
    wl-clipboard
  ];

  # --- K3s ---
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = ["--write-kubeconfig-mode=644"];
  };

  environment.sessionVariables = {
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    PATH = "$HOME/go/bin:$PATH";
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  # --- Autostart Guake ---
  environment.etc."xdg/autostart/guake.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Guake Terminal
    Exec=${pkgs.guake}/bin/guake
    X-GNOME-Autostart-enabled=true
    Comment=Start Guake on login
  '';

  # --- SSH ---
  services.openssh.enable = true;
  # services.openssh.settings = {
  #   PasswordAuthentication = true;
  #   KbdInteractiveAuthentication = true;
  #   PermitRootLogin = "no";
  # };

  system.stateVersion = "25.11";
}
