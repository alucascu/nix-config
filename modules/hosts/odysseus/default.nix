{inputs, ...}: {
  flake.modules.nixos.odysseus = {
    inputs,
    pkgs,
    ...
  }: {
    imports =
      [
        ./_hardware-configuration.nix
      ]
      ++ (with inputs.self.modules.nixos; [
        desktop
        docker
        quickemu
        gaming
        work
        alucascu
        agenix
        v4l2loopback
        obs-studio
        sunshine
        nvidia-telemetry
        pki
        wireguard
      ]);

    home-manager.users.alucascu.myConfig.sshKeyName = "odysseus";

    networking = {
      hostName = "odysseus";
      wireguard.interfaces.wg0.ips = ["10.100.0.3/24"];
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
        ensureProfiles.profiles.eno1 = {
          connection = {
            id = "eno1";
            type = "ethernet";
            interface-name = "eno1";
            autoconnect-priority = 10;
          };
          ipv4 = {
            method = "manual";
            address1 = "10.93.247.120/24";
            gateway = "10.93.247.97";
            dns = "10.93.247.97;";
            dns-search = "home.arpa;";
          };
          ipv6.method = "auto";
        };
      };
    };

    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };

    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
    };
    services.xserver.videoDrivers = ["nvidia"];

    # nixpkgs builds sunshine without CUDA, so NVENC cannot dlopen libcuda and
    # encoding falls back to Vulkan with a GPU -> RAM -> GPU copy per frame.
    # Overridden per-package: a global cudaSupport would rebuild half the closure.
    services.sunshine.package = pkgs.sunshine.override {cudaSupport = true;};

    boot = {
      loader.limine.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = ["iommu=pt" "panic=30"];
      extraModprobeConfig = ''
        options mt7925e disable_aspm=1
      '';
    };

    # kwin splits KWIN_DRM_DEVICES on ":", so a /dev/dri/by-path/ name is
    # unusable -- its PCI address contains colons. Give the dGPU a stable,
    # colon-free alias instead; DRM card numbers are probe-order dependent.
    services.udev.extraRules = ''
      SUBSYSTEM=="drm", KERNEL=="card*", SUBSYSTEMS=="pci", DRIVERS=="nvidia", SYMLINK+="dri/nvidia-card"
    '';

    environment.sessionVariables = {
      KWIN_DRM_DEVICES = "/dev/dri/nvidia-card";
    };

    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      vlc
      ffmpeg
      mpv
      math
      drawio

      neovim-rust
      neovim-ocaml
      neovim-tex
      neovim-typescript
      neovim-julia
    ];

    system.stateVersion = "25.11";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "odysseus";
}
