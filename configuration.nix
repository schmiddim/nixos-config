# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
  ];

  nix.nixPath = [
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  ];

  # cleanup old stuff
  nix.gc = {
    automatic = true;
    dates = "weekly"; # oder "daily"
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ms = import ./home/home.nix;

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Use latest kernel.
    #  boot.kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages;
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    kernelModules = [ "evdi" ];
    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
    ];
  };

  systemd.services.thunderbolt-pre-sleep = {
    description = "Thunderbolt pre-suspend";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/true";
    };
  };

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

  programs = {
    zsh.enable = true;
    seahorse.enable = true;
    nix-ld.enable = true; # for intellij
    regreet.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr

    ];
  };
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    avahi.enable = true;
    avahi.nssmdns4 = true;
    pulseaudio.enable = false;
    flatpak.enable = true;
    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      wireplumber.extraConfig = {
        "11-bluetooth-policy" = {
          "wireplumber.settings" = {
            "bluetooth.autoswitch-profile" = true;
          };
        };
      };
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

    };
    k3s = {
      enable = true;
      role = "server";
      extraFlags = [ "--write-kubeconfig-mode=644" ];
    };
    # List services that you want to enable:
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
      };
    };

    greetd.enable = true;
    xserver.enable = false;
    gnome.gnome-keyring.enable = true;
    # Firmware Updates
    fwupd.enable = true;
    hardware.bolt.enable = true;

    # Erforderlich, um den DisplayLink-Manager Dienst zu starten
    # (Dies aktiviert keinen X-Server, solange services.xserver.enable = false bleibt)
    xserver.videoDrivers = [
      "displaylink"
      "modesetting"
    ];
    udev.extraRules = ''
      # DisplayLink (D6000) Power Management Fix
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="17e9", ATTR{power/control}="on"
    '';

  };

  # Enable sound with pipewire.
  security = {
    rtkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true; # #hmm
    polkit.enable = true;
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

  environment.systemPackages = with pkgs; [
    git
    usbutils
    vim
    gnumake
    htop
    regreet
    libinput
    xdg-utils
    xdg-desktop-portal-wlr
    bluez
    bluez-tools
    bluetui

  ];

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  hardware = {

    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;

        };
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  fonts = {
    fontconfig.enable = true;
    fontDir = {
      enable = true;
    };
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
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
