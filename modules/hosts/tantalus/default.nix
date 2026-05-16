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
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
};

    system.stateVersion = "25.11";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "tantalus";
}
