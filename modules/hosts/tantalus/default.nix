{inputs, ...}: {
  flake.modules.nixos.tantalus = {
    inputs,
    pkgs,
    ...
  }: {
    imports =
      [./_hardware-configuration.nix]
      ++ (with inputs.self.modules.nixos; [
        system-cli
        docker
        immich
        alucascu
      ]);

    home-manager.users.alucascu.myConfig.sshKeyName = "tantalus";
    networking.hostName = "tantalus";
    networking.networkmanager.enable = true;

    fileSystems = {
      "/mnt/atlas" = {
        device = "/dev/disk/by-label/atlas";
        fsType = "ext4";
      };
      "/mnt/triton" = {
        device = "/dev/disk/by-label/triton";
        fsType = "ext4";
      };
    };

    services = {
      openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
      };

      immich.mediaLocation = "/mnt/atlas/immich";
    };

    boot = {
      initrd.kernelModules = ["amdgpu"];
      loader.limine.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    system.stateVersion = "25.11";
  };

  flake.nixosConfigurations =
    inputs.self.lib.mkNixos "x86_64-linux" "tantalus";
}
