# Configuration file for Dell Precision 5510
# Host: Dell Inc. 0W7V82
# CPU:  Intel i5-6300HQ (4) @ 3.200GHz - Skylake
# GPU:  NVIDIA Quadro M1000M - Maxwell (nvidia properietary driver) - muxless/non-MXM Optimus card (3D Controller)
# GPU:  Intel HD Graphics 530 - Gen9 Intel GPU (intel-media-driver) - MXM / output-providing card (VGA Controller)
# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Home Manager NixOS module
      <home-manager/nixos>
    ];
  
  # Bootloader
  boot = {
    loader = {
      # enable the systemd-boot (formerly gummiboot) EFI boot manager
      systemd-boot.enable = true;
      # installation process is allowed to modify EFI boot variables
      efi.canTouchEfiVariables = true;
    };

    # Custom kernel commandline: provide shell on fail
    kernelParams = [ "boot.shell_on_fail" ];

    # Prevent booting to ttyl on Nvidia
    initrd.kernelModules = [ "nvidia" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };

  # Networking
  networking = {
    # hostname
    hostName = "precision5510";

    networkmanager = {
      # Enable networking - turn off to prevent spofity offline mode while using wpa_supplicant
      #enable = true;
      # Note: use nmtui to connect to wifi on ttyl/rescue mode
      unmanaged = [ "interface-name:wlp2s0" ];
    };

    wireless = {
      # You cannot use networking.networkmanager with networking.wireless.
      # Unless you mark some interfaces as unmanaged by networkmanager
      enable = true;  # Enables wireless support via wpa_supplicant.
      userControlled.enable = true;
      networks = {
        TP-Link_D5CA = {
          pskRaw = "4549d8c35c0ff7cd552a760930f8a0f38912d7cfb3dc5351a58d8644c24984c8";
          priority = 2;
        };
        AndroidAP_2837 = {
          pskRaw = "c2337cacac639a449a00fff137039b927b866480efff4fc5ef9918b93134d14b";
          priority = 1;
        };
        "Galaxy S10e8f21" = {
          pskRaw = "05a32002fa5b592853e1bcac185a7f3172a0c1c1638c932d0ffae2c5b376516b";
          priority = 1;
        };
        Sweppenberg = {
          pskRaw = "df13ee579dd61395c45bd21e29d6b0e8d4e4febfba9f0aadde29975471def425";
          priority = 2;
        };
      };
    };

    firewall = {
      enable = true;
      # Open ports in the firewall.
      # 7070 AnyDesk, 80 HTTP, 443 HTTPS
      allowedTCPPorts = [ 80 443 7070 59100 ];
      # 53 - DNS, 59100 - AudioRelay
      allowedUDPPorts = [ 53 59100 ];
      # port ranges
      allowedTCPPortRanges = [
          { from = 1714; to = 1764; }
      ];
      allowedUDPPortRanges = [
          { from = 1714; to = 1764; }
      ];
    };
  };

  hardware = {
    # Enable bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      # Enabling A2DP Sink
      settings.General.Enable = "Source,Sink,Media,Socket";
    };

    # bluetooth with PulseAudio
    pulseaudio = {
      # pipewire in use
      enable = false;
      # Enabling extra codecs
      package = pkgs.pulseaudioFull;
      # automatically switch audio to the connected bluetooth
      extraConfig = "load-module module-switch-on-connect";
    };

    # GPU Acceleration
    # Make sure opengl is enabled
    opengl = {
      # OpenGL - 3D graphics
      enable = true;
      # Vulkan - 3D graphics;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        # VA-API - video playback
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        # VDPAU - video playback
        vaapiVdpau
        libvdpau-va-gl
        # OpenCL - general-purpose computing
        intel-compute-runtime
      ];
      # extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel ];
    };

    # Completely disable the NVIDIA graphics card and use the integrated graphics processor instead.
    #nvidiaOptimus.disable = true;

    # Nvidia configuration
    nvidia = {

      # Modesetting is needed for most wayland compositors
      modesetting.enable = true;

      # Enable power management (do not disable this unless you have a reason to).
      # Likely to cause problems on laptops and with screen tearing if disabled.
      powerManagement.enable = true;
      # Experimental power management of PRIME offload: reduces fan noise/heat
      powerManagement.finegrained = true;

      # Use the open source version of the kernel module ("nouveau")
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    
      # Nvidia PRIME
      prime = {
        # Optimus PRIME Option A: Offload Mode
        # Use offload command to turn on Nvidia when needed
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # Optimus PRIME Option B: Sync Mode
        # Nvidia always on and used for all rendering
        #sync.enable = true;

        # Optimus Option C: Reverse Sync Mode (Experimental)
        # Nvidia handles output to external display
        #reverseSync.enable = true;

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Africa/Nairobi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";

      # Exclude default xorg packages
      excludePackages = with pkgs; [
        xterm
      ];

      displayManager = {
        # Enable sddm as the display manager.
        sddm = {
          enable = true;
          enableHidpi = true;
          autoNumlock = true;
        };

        # Launch KDE in Wayland session
        #defaultSession = "plasmawayland";
      };

      # Enable the KDE Plasma Desktop Environment.
      desktopManager.plasma5 = {
        enable = true;
        # Enable HiDPI scaling in Qt.
        useQtScaling = true;
      };

      dpi = 282;
      
      # Upscale the default X cursor to be more visible on high-density displays
      upscaleDefaultCursor = true;

      libinput = {
        # Enable touchpad support (enabled default in most desktopManager).
        enable = true;
        # other mice/touchpad settings
        mouse = {
          accelProfile = "adaptive";
          naturalScrolling = true;
          scrollMethod = "twofinger";
        };
        touchpad = {
          tapping = true;
          accelProfile = "adaptive";
          naturalScrolling = true;
          clickMethod = "buttonareas";
        };
      };

      # Tell X11 to use the properietary nvidia driver
      videoDrivers = [ "nvidia" ];
    };

    # enable ddccontrol for controlling displays
    ddccontrol.enable = true;

    # Enable pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  environment = {
    # Exclude default KDE plasma packages
    plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa
      khelpcenter
      print-manager
    ];

    # packages installed in system profile
    systemPackages = with pkgs; [
      nano
      firefox
      notepadqq
      libsForQt5.kdeconnect-kde
      spotify
      kmail
      audacity
      anydesk
      gimp
      onlyoffice-bin
      rclone
      rclone-browser
      vlc
      vscode
      handbrake
      libsForQt5.kirigami-addons
      pitivi
      distrobox
      gnome-frog
      libsForQt5.kcalc
      copyq
      etcher
      intel-gpu-tools
      neofetch
      mcfly
      bat
      android-tools
      git
      wget
      nix-zsh-completions
      meslo-lgs-nf
      zsh-powerlevel10k
      mlocate
      htop
      bleachbit
      gparted
      brave
      (python311.withPackages(ps: with ps; [ tkinter ]))
      xorg.xhost # distrobox access to xserver
      wpa_supplicant_gui
      #(builtins.getFlake "github:JamesReynolds/audiorelay-flake").defaultPackage.x86_64-linux
    ];

    # environment variables that are available system-wide
    variables = {
      LIBVA_DRIVER_NAME = "iHD"; # or i965 (install vaapiIntel)
    };

    # use Zsh shell
    shells = with pkgs; [ zsh ];
    
    # Allow containers (distrobox/podman) to connect to xserver
    loginShellInit = ''
      xhost +local:
    '';
    
    # completion for system packages
    pathsToLink = [ "/share/zsh" ];
  };

  programs = {
    # GTK themes are not applied in Wayland applications/Window management buttons missing
    # see https://user-images.githubusercontent.com/40663462/178008862-0eea9ade-dd8b-4030-85af-e87ef24911fd.png
    dconf.enable = true;

    # Command Shell: zsh
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      # If you want to reduce the startup time of your shells
      #enableGlobalCompInit = false;
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      shellAliases = {
        upgrade = "sudo nix-channel --update && sudo nixos-rebuild switch --upgrade";
        update = "sudo nix-channel --update";
        switch = "sudo nixos-rebuild switch";
        testc = "sudo nixos-rebuild test";
      };
      ohMyZsh = {
        enable = true;
        plugins = [ "sudo"];
		    #theme = "robbyrussell";
      };
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;

  users = {
    users = {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      pcf26536 = {
        isNormalUser = true;
        home  = "/home/pcf26536";
        # generate hash using "mkpasswd -m sha-512"
        # change user password using "passwd" command
        hashedPassword = "$6$gW4Y1P/EdJRmGptY$a/nwAew1mcAqasqOriso/osliwhvAlaDXGSim3wgSDa3bNLUAnOGy83a6UjmnwyKPpfzjP1zSVcramogqkXW41";
        description = "Wainaina Gichuhi";
        extraGroups = [ "networkmanager" "wheel" ];
      };

      root = {
        # generate hash using "mkpasswd -m sha-512" command
        hashedPassword = "$6$gW4Y1P/EdJRmGptY$a/nwAew1mcAqasqOriso/osliwhvAlaDXGSim3wgSDa3bNLUAnOGy83a6UjmnwyKPpfzjP1zSVcramogqkXW41";
      };  
    };

    defaultUserShell = pkgs.zsh;
  };

  # integrated home manager configurations
  home-manager.users.pcf26536 = {
    home = {
      stateVersion = "23.05";
      sessionPath = [
        "/data/Repositories/nixos-config"
      ];
    };

    programs = {
      # bat
      bat = {
        enable = true;
        config.theme = "GitHub";
      };

      # git
      git = {
        enable = true;
        userName  = "pcf26536";
        userEmail = "muffwaindan@gmail.com";
        lfs.enable = true;
        extraConfig.init.defaultBranch = "main";
      };

      # mcfly
      mcfly = {
        enable = true;
        enableLightTheme = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      zsh.historySubstringSearch.enable = true;
    };
    
    xdg.userDirs = {
      enable = true;
      documents = "/data/Documents";
      download = "/data/Downloads";
      music = "/data/Music";
      pictures = "/data/Pictures";
      videos = "/data/Videos";
    };
      
    # Using Bluetooth headset buttons to control media player
    systemd.user.services.mpris-proxy = {
      Unit = {
        Description =
          "Proxy forwarding Bluetooth MIDI controls via MPRIS2 to control media players";
        BindsTo = [ "bluetooth.target" ];
        After = [ "bluetooth.target" ];
      };

      Install.WantedBy = [ "bluetooth.target" ];

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      };
    };
  };

  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;

    # etcher depedency
    permittedInsecurePackages = [
      "electron-12.2.3"
    ];

    # NVIDIA Quadro M1000M: NVIDIA on NixOS - https://nixos.wiki/wiki/Nvidia
    # NVIDIA drivers are unfree.
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced" # the daemon prevents the driver from releasing device state when the device is not in use
      ];
  };

  # Virtualisation
  virtualisation = {
    podman = {
      enable = true;
      enableNvidia = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # File Systems
  # check compatibility e2fsprogs - e2fsck (Feature C12 on 1.47.0 and later)
  # make sure to mount /nix during installation
  # /nix filesystem will be automatically defined in hardware-configuration.nix
  
  fileSystems."/data" = { 
    device = "/dev/disk/by-label/data";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  # Automatic Upgrades
  system = {
    autoUpgrade = {
      enable = true;
      operation = "boot";
      dates = "Tue 02:00";
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "23.05"; # Did you read the comment?
  };
  
  # Managing storage
  nix = {
    # automatically do daily garbage collection
    gc.automatic = true;
    settings = {
      # Deduplication
      auto-optimise-store = true;
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

}
