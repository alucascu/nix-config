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

      restic = {
        backups = {
          immich-atlas = {
            paths = ["/mnt/atlas/immich/"];
            repository = "/mnt/atlas/restic-repo";
            passwordFile = "/etc/restic-password";
            timerConfig = {
              OnCalendar = "daily";
              Persistent = true;
            };
          };
          immich-triton = {
            paths = ["/mnt/atlas/immich/"];
            repository = "/mnt/triton/restic-repo";
            passwordFile = "/etc/restic-password";
            timerConfig = {
              OnCalendar = "daily";
              Persistent = true;
            };
          };
          immich-proton = {
            paths = ["/mnt/atlas/immich"];
            repository = "rclone:proton:immich-backup";
            passwordFile = "/etc/restic-password";
            rcloneConfigFile = "/etc/rclone/rclone.conf";
            timerConfig = {
              OnCalendar = "daily";
              Persistent = true;
            };
          };
        };
      };
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
