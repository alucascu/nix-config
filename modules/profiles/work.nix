{inputs, ...}: {
  flake.modules.nixos.work = {
    imports = with inputs.self.modules.nixos; [
      chromium
      globalprotect
    ];

    home-manager.sharedModules = [inputs.self.modules.homeManager.work];
  };

  flake.modules.homeManager.work = {pkgs, ...}: {
    home.packages = with pkgs; [
      slack
      zoom-us
    ];
  };
}
