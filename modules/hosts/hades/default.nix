{inputs, ...}: {
  flake.modules.nixos.hades = {
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
        work
        fprintd
        globalprotect
      ]);

    swapDevices = lib.mkForce [];

    home-manager.users.alucascu.myConfig.sshKeyName = "hades";
    networking = {
      hostName = "hades";
      networkmanager.enable = true;
      wireless.enable = true;
    };
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    boot = {
      loader.limine.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
    };
    system.stateVersion = "25.11";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "hades";
}
