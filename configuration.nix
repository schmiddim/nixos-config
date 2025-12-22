# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #    <nixos-hardware/lenovo/thinkpad/p52>
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_6;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    evdi
  ];

  boot.kernelModules = [ "evdi" ];

  networking.hostName = "p52-nixos"; # Define your hostname.

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

  # Mouse Hack on Thinkpad
  #  boot.kernelModules = [ "psmouse"];
  #  boot.extraModprobeConfig = "options psmouse proto=imps";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [
    "displaylink"
    "modesetting"
  ];

  services.xserver.desktopManager.cinnamon.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  # Keychron = us (per device)
services.xserver.displayManager.sessionCommands = ''
  id="$(xinput list | awk -F'id=' '/Keychron/ && /Keyboard/ && /slave  keyboard/ {print $2}' | awk '{print $1; exit}')"
  if [ -n "$id" ]; then
    setxkbmap -device "$id" -model pc105 -layout us
  fi

  # --- Touchpad  ---
  tp_id="$(xinput list | awk -F'id=' '/Touchpad/ {print $2}' | awk '{print $1; exit}')"
  if [ -n "$tp_id" ]; then
      xinput disable "$tp_id"
  fi
'';
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.drivers = with pkgs; [
    hplip
  ];
  programs.system-config-printer.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

# Autostart guake
  environment.etc."xdg/autostart/guake.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Guake Terminal
    Exec=${pkgs.guake}/bin/guake

 #   OnlyShowIn=X-Cinnamon;
    X-GNOME-Autostart-enabled=true
    Comment=Start Guake on login
  '';



  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" ];
    };
  };

  programs.zsh.interactiveShellInit = ''
    autoload -Uz compinit
    compinit
    zstyle ':completion:*:-command-:*' tag-order '!parameters'
  '';
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ms = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "ms";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  nix.extraOptions = "experimental-features = nix-command flakes";

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    google-chrome
    jetbrains.idea # -ultimate
    kubectl
    k9s
    htop
    git
    guake
    go
    gotools
    gcc
    displaylink
    usbutils
    gh
    xorg.xinput
    xorg.setxkbmap
  ];

  environment.variables = {
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    PATH = "$HOME/go/bin:$PATH";
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  # kubernetes
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [
      "--write-kubeconfig-mode=644"
    ];
  };

# clean up builds older than 14d
nix.gc = {
  automatic = true;
  dates = "weekly";                 # oder "daily"
  options = "--delete-older-than 14d";
};
  #home.sessionPath = [
  #  "$HOME/go/bin"
  #  "$HOME/bin"
  #];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programstr.enable = true;
  # programs.gnupg.agent = {
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  system.stateVersion = "25.11"; # Did you read the comment?

}
