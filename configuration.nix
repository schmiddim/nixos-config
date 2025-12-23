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

  boot.kernelModules = ["psmouse"];
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
  security.polkit.enable = true; # (wichtig für viele Desktop-Aktionen) :contentReference[oaicite:0]{index=0}

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # GTK-Apps bekommen die richtigen Env-Variablen :contentReference[oaicite:1]{index=1}
    extraPackages = with pkgs; [
      # Basics, damit du nicht "nackt" dastehst:
      swaylock
      swayidle
      waybar
      mako
      grim
      slurp
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
    networkmanagerapplet   # nm-applet
    swaylock
    swayidle
    waybar
    mako
    grim
    slurp
    wl-clipboard
  ];

  services.gnome.gnome-keyring.enable = true;
environment.etc."sway/config".text = ''
#########################
############################
# Sway – komplette Basis
############################

### Mod-Taste
set $mod Mod4

############################
# Programme / Launcher
############################

# Terminal
bindsym $mod+Return exec alacritty

# App Launcher
bindsym $mod+d exec wofi --show drun

# Dateimanager
bindsym $mod+e exec thunar

############################
# Fenstersteuerung
############################

# Fenster schließen
bindsym $mod+Shift+q kill

# Floating toggle
bindsym $mod+Shift+space floating toggle

# Fullscreen
bindsym $mod+f fullscreen toggle

# Fokus bewegen
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# Fenster verschieben
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

############################
# Workspaces
############################

set $ws1 "1:web"
set $ws2 "2:code"
set $ws3 "3:term"
set $ws4 "4:files"

bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4

bindsym $mod+Shift+1 move container to workspace $ws1
bindsym $mod+Shift+2 move container to workspace $ws2
bindsym $mod+Shift+3 move container to workspace $ws3
bindsym $mod+Shift+4 move container to workspace $ws4

############################
# Reload / Exit
############################

# Config neu laden
bindsym $mod+Shift+c reload

# Sway beenden
bindsym $mod+Shift+e exec "swaymsg exit"

############################
# Lock Screen
############################

# Manuell sperren
bindsym $mod+Shift+l exec swaylock -f -c 000000

# Automatisch sperren + Display aus
exec_always swayidle -w \
  timeout 300 'swaylock -f -c 000000' \
  timeout 600 'swaymsg "output * dpms off"' \
  resume 'swaymsg "output * dpms on"'

############################
# Autostart / Tray
############################

# WLAN / Netzwerk
exec_always nm-applet

# Benachrichtigungen
exec_always mako

############################
# Input
############################

# Touchpad nur aktiv, wenn keine Maus
input type:touchpad {
  events disabled_on_external_mouse
}

############################
# Statusleiste
############################

bar {
  position top
  swaybar_command waybar
}

############################
# Optik / Verhalten
############################

# Fensterrahmen minimal
default_border pixel 2
gaps inner 6
gaps outer 3

# Maus + Mod = Fenster bewegen
floating_modifier $mod

#######################
'';

environment.etc."xdg/waybar/style.css".text = ''
* {
  font-family: Inter, sans-serif;
  font-size: 12px;
}

window#waybar {
  background: #1e1e2e;
  color: #cdd6f4;
}

#workspaces button {
  padding: 0 8px;
  color: #cdd6f4;
}

#workspaces button.focused {
  background: #89b4fa;
  color: #1e1e2e;
}

#clock, #network, #battery {
  padding: 0 10px;
}
'';


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
