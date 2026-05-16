{inputs, ...}: {
  flake.modules.nixos.tantalus = {
    inputs,
    pkgs,
    lib,
    ...
  }: {
    imports =
      [
        ./_hardware-configuration.nix
      ]
      ++ (with inputs.self.modules.nixos; [
        system-desktop
        docker
        alucascu
      ]);

    home-manager.users.alucascu.myConfig.sshKeyName = "tantalus";

    networking = {
      hostName = "tantalus";
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };

    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };


    boot = {
      initrd.kernelModules = ["amdgpu"];
      loader.limine.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
      extraModprobeConfig = ''
        options mt7925e disable_aspm=1
      '';
    };

    environment.sessionVariables = {
      KWIN_DRM_DEVICES = "/dev/dri/card2";
    };

    system.stateVersion = "25.11";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "tantalus";
}
