{inputs, ...}: {
  flake.modules.nixos.heimdall = {
    inputs,
    lib,
    ...
  }: {
    imports =
      [inputs.nixos-wsl.nixosModules.default]
      ++ (with inputs.self.modules.nixos; [
        system-cli
        alucascu
      ]);

    wsl = {
      enable = true;
      defaultUser = "alucascu";
    };

    hardware = {
      enableRedistributableFirmware = lib.mkForce false;
      bluetooth.enable = lib.mkForce false;
    };
    services.fwupd.enable = lib.mkForce false;

    home-manager.users.alucascu.myConfig.sshKeyName = "heimdall";

    networking.hostName = "heimdall";

    system.stateVersion = "26.05";
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "heimdall";
}
