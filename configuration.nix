# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
  ];

  nix.nixPath = [
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ms = import ./home/home.nix;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
#  boot.kernelPackages = pkgs.linuxPackages_latest;
boot.kernelPackages = pkgs.linuxPackages;
boot.extraModulePackages = [ config.boot.kernelPackages.evdi ];
boot.kernelModules = [ "evdi" ];
# Erforderlich, um den DisplayLink-Manager Dienst zu starten
# (Dies aktiviert keinen X-Server, solange services.xserver.enable = false bleibt)
services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

services.udev.extraRules = ''
  # DisplayLink (D6000) Power Management Fix
  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="17e9", ATTR{power/control}="on"
'';

boot.kernelParams = [
"intel_iommu=on"
  "iommu=pt"
];
systemd.services.thunderbolt-pre-sleep = {
  description = "Thunderbolt pre-suspend";
  before = [ "sleep.target" ];
  wantedBy = [ "sleep.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.coreutils}/bin/true";
  };
};

#services.udev.extraRules = ''
#  ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
#'';

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

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

  services.greetd.enable = true;
  programs.regreet.enable = true;
  services.xserver.enable = false;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true; ##hmm

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

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

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ms = {
    isNormalUser = true;
    description = "ms";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };


  programs.zsh.enable = true;
  programs.nix-ld.enable = true; # for intellij

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    usbutils
    vim
    gnumake
    htop
    regreet
    libinput
  ];
  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [ "--write-kubeconfig-mode=644" ];
  };
  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = true;
    KbdInteractiveAuthentication = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly"; # oder "daily"
    options = "--delete-older-than 14d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

# Firmware Updates
services.fwupd.enable = true;
services.hardware.bolt.enable = true;
hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };


  environment.sessionVariables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    XDG_CACHE_HOME = "$HOME/.cache";

    # WLR_DRM_DEVICES = "..."; # Erstmal auskommentieren!
        WLR_NO_HARDWARE_CURSORS = "1";
        # Erforderlich für Nvidia + Wayland/Sway:
        WLR_RENDERER = "vulkan";
        XDG_CURRENT_DESKTOP = "sway";
  };

  system.stateVersion = "25.11"; # Did you read the comment?

}
