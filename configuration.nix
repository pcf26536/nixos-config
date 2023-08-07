# Configuration file for Dell Precision 5510
# Host: Dell Inc. 0W7V82
# CPU:  Intel i5-6300HQ (4) @ 3.200GHz - Skylake
# GPU:  NVIDIA Quadro M1000M - Maxwell (nvidia properietary driver)
# GPU:  Intel HD Graphics 530 - Gen9 Intel GPU (intel-media-driver)
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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Custom kernel commandline
  boot.kernelParams = [ "boot.shell_on_fail" ];

  # Booting to ttyl fix (NVIDIA)
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  networking.hostName = "precision5510"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # Note: use nmtui to connect to wifi on ttyl/rescue mode
  networking.networkmanager.unmanaged = [ "interface-name:wlp2s0" ];
  # You cannot use networking.networkmanager with networking.wireless.
  # Unless you mark some interfaces as unmanaged by networkmanager
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.userControlled.enable = true;
  networking.wireless.networks = {
	  TP-Link_D5CA = {
	  	pskRaw = "4549d8c35c0ff7cd552a760930f8a0f38912d7cfb3dc5351a58d8644c24984c8";
		  priority = 1;
	  };
	};

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # Enable blueman (bluetooth GUI manager)
  #services.blueman.enable = true;
  # bluetooth with PulseAudio
  # Enabling extra codecs
  hardware.pulseaudio = {
    package = pkgs.pulseaudioFull;
    # automatically switch audio to the connected bluetooth
    extraConfig = "load-module module-switch-on-connect";
  };
  # Enabling A2DP Sink
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  # Set your time zone.
  time.timeZone = "Africa/Nairobi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Exclude default xorg packages
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];


  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # Launch KDE in Wayland session
  services.xserver.displayManager.defaultSession = "plasmawayland";

  # Exclude default KDE plasma packaes
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    khelpcenter
    print-manager
  ];

  # GTK themes are not applied in Wayland applications
  # see https://user-images.githubusercontent.com/40663462/178008862-0eea9ade-dd8b-4030-85af-e87ef24911fd.png
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;
  # other mice/touchpad settings
   services.xserver.libinput.mouse.accelProfile = "adaptive";
   services.xserver.libinput.mouse.naturalScrolling = true;
   services.xserver.libinput.mouse.scrollMethod = "twofinger";
   services.xserver.libinput.touchpad.tapping = true;
   services.xserver.libinput.touchpad.accelProfile = "adaptive";
   services.xserver.libinput.touchpad.naturalScrolling = true;
   services.xserver.libinput.touchpad.clickMethod = "buttonareas";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pcf26536 = {
    isNormalUser = true;
    home  = "/home/pcf26536";
    # generate hash using "mkpasswd -m sha-512"
    # change user password using "passwd" command
	  hashedPassword = "$6$gW4Y1P/EdJRmGptY$a/nwAew1mcAqasqOriso/osliwhvAlaDXGSim3wgSDa3bNLUAnOGy83a6UjmnwyKPpfzjP1zSVcramogqkXW41";
    description = "Wainaina Gichuhi";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      
    ];
  };

  users.users.root = {
    # generate hash using "mkpasswd -m sha-512" command
    hashedPassword = "$6$gW4Y1P/EdJRmGptY$a/nwAew1mcAqasqOriso/osliwhvAlaDXGSim3wgSDa3bNLUAnOGy83a6UjmnwyKPpfzjP1zSVcramogqkXW41";
  };
  
  home-manager.users.pcf26536 = {
    home.stateVersion = "23.05";
    programs = {
      # bat
      bat = {
        enable = true;
        config = {
          theme = "GitHub";
        };
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
        enableZshIntegration = true;
      };

      zsh = {
        historySubstringSearch.enable = true;
        zplug = {
          enable = true;
          plugins = [
            { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
            { name = "plugins/git"; }
          ];
        };
      };
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # etcher depedency
  nixpkgs.config.permittedInsecurePackages = [
    "electron-12.2.3"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # The Nano editor is also installed by default.
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
    whatsapp-for-linux
    etcher
    ytmdl
    intel-gpu-tools
    neofetch
    mcfly
    bat
    android-tools
    git
    wget
    nix-zsh-completions
    meslo-lgs-nf
    #zsh-powerlevel10k
    mlocate
    htop
    bleachbit
    gparted
  ];

  # environment variables that are available system-wide
  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD"; # or i965
  };

  # GPU Acceleration
  # Make sure opengl is enabled
  hardware.opengl = {
    # OpenGL - 3D graphics
    enable = true;
    # Vulkan - 3D graphics;
    driSupport = true;
    #driSupport32Bit = true;
    extraPackages = with pkgs; [
      # VA-API - video playback
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      #vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      # VDPAU - video playback
      vaapiVdpau
      libvdpau-va-gl
      # OpenCL - general-purpose computing
      intel-compute-runtime
    ];
    # extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel ];
  };

  # overrides to enable Intel's Hybrid Driver. 
  /* nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs = { 
      # vaapiIntel.override { enableHybridCodec = true; }; 
      intel-media-driver.override { enableHybridCodec = true; };
    };
  };*/

  # NVIDIA Quadro M1000M: NVIDIA on NixOS - https://nixos.wiki/wiki/Nvidia
  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  # Tell Xorg to use /enable the properietary nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
	
    # Nvidia PRIME
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Command Shell
  # zsh
  programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        upgrade = "sudo nix-channel --update && sudo nixos-rebuild switch --upgrade";
        update = "sudo nix-channel --update";
        switch = "sudo nixos-rebuild switch";
        testc = "sudo nixos-rebuild test";
      };
      /*ohMyZsh = {
        enable = true;
        plugins = [ "git" "thefuck" "sudo"];
		    theme = "robbyrussell";
        #theme = "powerlevel10k";
      };
      /*plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];*/
  };
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  # completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Virtualisation
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      # For Nixos version > 22.11
      #defaultNetwork.settings = {
      # dns_enabled = true;
      #};
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

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    # Open ports in the firewall.
    # 7070 AnyDesk, 80 HTTP, 443 HTTPS
    allowedTCPPorts = [ 80 443 7070 59100 ];
    # 53 - DNS, 59100 - AudioRelay
    allowedUDPPorts = [ 53 59100 ];
  };
  networking.firewall.allowedTCPPortRanges = [
      { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
      { from = 1714; to = 1764; }
  ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Automatic Upgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  
  # Managing storage
  # automatically do daily garbage collection
  nix.gc.automatic = true;
  # Deduplication
  nix.settings.auto-optimise-store = true;

}
