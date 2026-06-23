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
        system-desktop
        docker
        gaming
        work
        alucascu
        agenix
      ]);

    home-manager.users.alucascu.myConfig.sshKeyName = "odysseus";

    networking = {
      hostName = "odysseus";
      wireguard.interfaces.wg0.ips = ["10.100.0.3/24"];
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };

    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };

    hardware.nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    services.xserver.videoDrivers = ["nvidia"];

    boot = {
      loader.limine.enable = true;
      loader.efi.canTouchEfiVariables = true;
      initrd.kernelModules = ["amdgpu"];
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = ["iommu=pt" "panic=30"];
      extraModprobeConfig = ''
        options mt7925e disable_aspm=1
      '';
    };

    environment.sessionVariables = {
      KWIN_DRM_DEVICES = "/dev/dri/card2";
    };

    home-manager.users.alucascu.imports = [
      inputs.self.modules.homeManager.gaming
    ];

    system.stateVersion = "25.11";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "odysseus";
}
