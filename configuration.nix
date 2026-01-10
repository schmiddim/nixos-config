# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.warn-dirty = false; # flakes sollen ohne git-Status-Gate funktionieren

  imports = [
    ./hardware-configuration.nix
  ];

  # cleanup old stuff
  nix.gc = {
    automatic = true;
    dates = "weekly"; # oder "daily"
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = false;
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
      "usbcore.autosuspend=-1" # usb docking station

      # TrackPoint / psmouse Stabilität
      "psmouse.synaptics_intertouch=0"
      "psmouse.resetafter=0"
      "psmouse.smps=1"
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

  networking.hostName = "p52"; # Define your hostname.
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
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="17e9", TEST=="power/control", ATTR{power/control}="on"

      # Default: USB no wakeup
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
      # External Keybaord can wakeup
      ACTION=="add", SUBSYSTEM=="input", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", ATTR{power/wakeup}="enabled"

    '';
    grafana = {
      enable = true;
      settings.server.http_addr = "127.0.0.1";
      provision = {
        enable = true;
        datasources = {
          settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://localhost:9090";
              isDefault = true;
            }
            {
              name = "Loki";
              type = "loki";
              url = "http://localhost:3100";
            }
          ];
        };
      };
    };
    prometheus = {
      enable = true;
      retentionTime = "7d";
      scrapeConfigs = [
        {
          job_name = "prometheus";
          static_configs = [
            { targets = [ "localhost:9090" ]; }
          ];
        }
        {
          job_name = "node";
          static_configs = [
            {
              targets = [
                "localhost:${toString config.services.prometheus.exporters.node.port}"
              ];
            }
          ];
        }
      ];
    };
    prometheus.exporters.node = {
      enable = true;
      port = 9100;
    };
    loki = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 3100;
          grpc_listen_port = 9095;
        };
        auth_enabled = false;
        common = {
          instance_addr = "127.0.0.1";
          path_prefix = "/var/lib/loki";
          ring.kvstore.store = "inmemory";
          replication_factor = 1;
          storage.filesystem = {
            chunks_directory = "/var/lib/loki/chunks";
            rules_directory = "/var/lib/loki/rules";
          };
        };
        schema_config.configs = [
          {
            from = "2024-01-01";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
        storage_config = {
          boltdb_shipper = {
            active_index_directory = "/var/lib/loki/index";
            cache_location = "/var/lib/loki/cache";
          };
          filesystem = {
            directory = "/var/lib/loki/chunks";
          };
        };
        limits_config = {
          retention_period = "168h";
          allow_structured_metadata = false;
        };
        compactor = {
          working_directory = "/var/lib/loki/compactor";
          compaction_interval = "10m";
          retention_enabled = true;
          delete_request_store = "filesystem";
        };
        ruler = {
          storage = {
            type = "local";
            local = {
              directory = "/var/lib/loki/rules";
            };
          };
          ring.kvstore.store = "inmemory";
        };
      };
    };
    promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 9080;
          grpc_listen_port = 0;
        };
        clients = [
          {
            url = "http://127.0.0.1:3100/loki/api/v1/push";
          }
        ];
        positions.filename = "/var/cache/promtail/positions.yaml";
        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              max_age = "12h";
              labels = {
                job = "systemd-journal";
                host = config.networking.hostName;
              };
            };
            relabel_configs = [
              {
                source_labels = [ "__journal__systemd_unit" ];
                target_label = "unit";
              }
            ];
          }
        ];
      };
    };
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
      "audio"
      "networkmanager"
      "video"
      "wheel"
      "input"
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
    mcp-grafana
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
