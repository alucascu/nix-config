{inputs, ...}: {
  flake.modules.homeManager.neovim = {
    imports = [
      inputs.lazyvim.homeManagerModules.default
      ./_extras.nix
      ./_packages.nix
      ./plugins/_conform.nix
      ./plugins/_lsp.nix
      ./plugins/_obsidian.nix
      ./config/_keymaps.nix
      ./config/_options.nix
    ];
  };
}
