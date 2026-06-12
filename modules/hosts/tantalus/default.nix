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
        freshrss
        ollama
        open-webui
        alucascu
      ]);

    home-manager.users.alucascu.myConfig.sshKeyName = "tantalus";

    networking = {
      hostName = "tantalus";
      networkmanager.enable = true;
      useDHCP = false;
      interfaces.enp14so = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "10.93.247.105";
            prefixLength = 24;
          }
        ];
      };
      defaultGateway = "10.93.247.97";
      nameservers = ["10.93.247.97"];
      firewall.allowedTCPPorts = [80 443];
    };

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
