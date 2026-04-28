{inputs, ...}: {
  flake.modules.homeManager.neovim = {
    imports = [
      inputs.lazyvim.homeManagerModules.default
      ./plugins
      ./config
      ./extras.nix
      ./packages.nix
    ];

    programs.lazyvim.enable = true;
  };
}
