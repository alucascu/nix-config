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
        alucascu
      ]);

    networking.hostName = "odysseus";
    networking.networkmanager.enable = true;
    networking.wireless.enable = true;

    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };

    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = false;
    };
    services.xserver.videoDrivers = ["nvidia"];

    boot.initrd.kernelModules = ["amdgpu"];

    boot = {
      loader.limine.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
    };

    home-manager.users.alucascu.imports = [
      inputs.self.modules.homeManager.gaming
    ];

    system.stateVersion = "25.11";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "odysseus";
}
