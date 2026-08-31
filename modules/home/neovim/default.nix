{inputs, ...}: {
  flake.modules.homeManager.neovim = {
    imports =
      [
        inputs.lazyvim.homeManagerModules.default
        ./_extras.nix
        ./plugins/_conform.nix
        ./plugins/_lsp.nix
        ./plugins/_colorscheme.nix
        ./plugins/_pomo.nix
        ./config/_keymaps.nix
        ./config/_options.nix
        ./plugins/_blink_luasnip.nix
        ./plugins/_oil.nix
        ./plugins/_tex.nix
        ./plugins/_markdown_preview.nix
      ]
      # Languages every target gets — cheap, and as useful on a server as on
      # a workstation. Heavier toolchains are opt-in per host; see
      # modules/home/neovim-langs/ for the full set and what each one costs.
      ++ (with inputs.self.modules.homeManager; [
        neovim-nix
        neovim-git
        neovim-toml
        neovim-markdown
        neovim-sql
        neovim-python
      ]);
  };
}
