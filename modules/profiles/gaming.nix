{inputs, ...}: {
  flake.modules.nixos.gaming = {pkgs, ...}: {
    home-manager.sharedModules = [inputs.self.modules.homeManager.gaming];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs.steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    programs.gamemode.enable = true;
  };

  flake.modules.homeManager.gaming = {pkgs, ...}: {
    programs.mangohud.enable = true;
    home.packages = [pkgs.prismlauncher];
  };
}
