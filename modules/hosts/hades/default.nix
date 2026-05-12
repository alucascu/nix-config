{inputs, ...}: {
  flake.modules.nixos.hades = {
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
        alucascu
        work
        fprintd
        globalprotect
      ]);

    home-manager.users.alucascu.myConfig.sshKeyName = "hades";

    networking.hostName = "hades";
    networking.networkmanager.enable = true;
    networking.wireless.enable = true;

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
