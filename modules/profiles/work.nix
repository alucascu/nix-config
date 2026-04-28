{inputs, ...}: {
  flake.modules.nixos.work = {
    imports = with inputs.self.modules.nixos; [
      chromium
    ];
  };

  flake.modules.homeManager.work = {
    imports = with inputs.self.modules.homeManager; [
      # work git identity, work ssh keys, etc. later
    ];

    programs.chromium = {
      enable = true;
      commandLineArgs = [
        "--profile-directory=work"
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
      ];
    };
  };
}
