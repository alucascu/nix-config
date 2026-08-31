{inputs, ...}: {
  flake.modules.nixos.desktop = {
    imports = with inputs.self.modules.nixos; [system-desktop];

    home-manager.sharedModules = [inputs.self.modules.homeManager.desktop];
  };

  flake.modules.homeManager.desktop = {
    imports = with inputs.self.modules.homeManager; [
      terminal
      desktop-apps
      browser
      starttree
      vscode
      discord
      tagstudio
      plasma
    ];
  };
}
