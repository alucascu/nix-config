{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  
  # Import NixOS modules
  imports = [
    ./hardware-configuration.nix
  ];
  
  nixpkgs = {
    overlays = [
      # Overlays exported from other flakes
      # neovim-nightly-overlay.overlays.default

      # Overlays defined inline
      # (final: prev: {
      #   hi = final.hello.overrideAttr (oldAttr: {
      #     patches = [./change-hello-to-hi.patch];
      #   });
      # });
    ];

    # Configure the nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      # enable flakes and nix-command
      experimental-features = "nix-command flakes";
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    
    # Latest linux kernel
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.luks.devices."luks-8a0d2ba6-be48-40a2-8b7f-920b39918f05".device = "/dev/disk/by-uuid/8a0d2ba6-be48-40a2-8b7f-920b39918f05";
  };

  networking.hostName = "hades";

  users.users = {
    alucascu = {
      # Skip setting root password by passing '--no-root-passwd'
      # Change using passwd after rebooting!
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # add SSH public keys
      ];
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
    };
  };

  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  time.timeZone = "America/Detroit";



  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };



  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      enable = true;
    };
  };

  services.desktopManager = {
      plasma6.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Install firefox.
  programs.firefox.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.dbus.implementation = "broker";

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    docker
    neovim
    wget
    tmux
    uv
  ];

  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  hardware.bluetooth.enable = true;

  programs.nix-ld.enable = true;



  # Do not mess with this unless you have a REALLY good reason!
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
