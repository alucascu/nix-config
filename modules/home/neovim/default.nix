{inputs, ...}: {
  flake.modules.homeManager.neovim = {
    imports = [
      inputs.lazyvim.homeManagerModules.default
      ./_extras.nix
      ./_packages.nix
      ./plugins/_conform.nix
      ./plugins/_lsp.nix
      ./plugins/_colorscheme.nix
      ./plugins/_pomo.nix
      ./config/_keymaps.nix
      ./config/_options.nix
      ./plugins/_blink_luasnip.nix
      ./plugins/_oil.nix
    ];
  };
}
