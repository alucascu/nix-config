{
  flake.modules.nixos.desktop = {inputs, ...}: {
    imports = with inputs.self.modules.nixos; [system-desktop];

    home-manager.users.alucascu.imports = with inputs.self.modules.homeManager; [
      plasma
    ];
  };
}
