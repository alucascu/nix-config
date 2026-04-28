{
  inputs,
  pkgs,
  ...
}: {
  flake.modules.nixos.hades = {
    imports =
      [
        ./hardware-configuration.nix
      ]
      ++ (with inputs.self.modules.nixos; [
        system-desktop
        docker
        asher
      ]);

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
