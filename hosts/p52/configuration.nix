{ config, pkgs, ... }:
{
  imports = [
    ../common/base.nix
    ../../hardware-configuration.nix
  ];

  networking.hostName = "p52";

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages;
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    kernelModules = [ "evdi" ];
    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "usbcore.autosuspend=-1"

      # TrackPoint / psmouse Stabilität
      "psmouse.synaptics_intertouch=0"
      "psmouse.resetafter=0"
      # Force Elan over PS/2; SMBus path triggers WARNs and freezes on this machine
      "psmouse.elantech_smbus=0"
      # More Trackpoint fixes
      "i8042.nomux=1"
      "i8042.nopnp=1"
      "i8042.reset=1"
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

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  services = {
    power-profiles-daemon.enable = true;
    thermald.enable = true;
    upower = {
      enable = true;
      usePercentageForPolicy = true;
      percentageLow = 10;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };
    k3s = {
      enable = true;
      role = "server";
      extraFlags = [
        "--write-kubeconfig-mode=644"
        "--disable traefik"
        "--disable metrics-server"
        "--disable servicelb"
        "--disable local-storage"
        "--kube-apiserver-arg=v=0"
        "--kube-controller-manager-arg=v=0"
        "--kube-scheduler-arg=v=0"
        "--kubelet-arg=v=0"
      ];
    };
    xserver = {
      enable = false;
      videoDrivers = [
        "displaylink"
        "modesetting"
      ];
    };
    udev.extraRules = ''
      # DisplayLink (D6000) Power Management Fix
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="17e9", TEST=="power/control", ATTR{power/control}="on"

      # Default: USB no wakeup
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
      # External Keybaord can wakeup
      ACTION=="add", SUBSYSTEM=="input", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", ATTR{power/wakeup}="enabled"

    '';
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

  system.stateVersion = "25.11";
}
