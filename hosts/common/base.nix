{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.warn-dirty = false;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = false;
  home-manager.useUserPackages = true;
  home-manager.users.ms = import ../../home/home.nix;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

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
    nix-ld.enable = true;
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
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services = {
    opensnitch.enable = true;
    printing.enable = true;
    avahi.enable = true;
    avahi.nssmdns4 = true;
    pulseaudio.enable = false;
    flatpak.enable = true;
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
    };
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
      };
    };
    greetd.enable = true;
    gnome.gnome-keyring.enable = true;
    fwupd.enable = true;
    hardware.bolt.enable = true;
    fstrim.enable = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  security = {
    rtkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
    polkit.enable = true;
  };

  users.users.ms = {
    isNormalUser = true;
    description = "ms";
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "video"
      "wheel"
      "input"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    kubectl
    usbutils
    vim
    gnumake
    htop
    iotop
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
}
