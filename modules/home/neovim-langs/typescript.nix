{...}: {
  # ~0.4 GB. The extra maps no packages; the language servers are ours.
  flake.modules.homeManager.neovim-typescript = {
    key = "neovim-typescript";

    imports = [
      ({pkgs, ...}: {
        programs.lazyvim.extras.lang.typescript.enable = true;

        programs.lazyvim.extraPackages = with pkgs; [
          vtsls
          prettierd
          vscode-langservers-extracted
        ];
      })
    ];
  };
}
