{
  flake.modules.homeManager.neovim-tex = {
    key = "neovim-tex";

    imports = [
      ({pkgs, ...}: {
        programs.lazyvim.extras.lang.tex.enable = true;

        programs.lazyvim.extraPackages = with pkgs; [
          ltex-ls-plus
          tex-fmt
          texlab
        ];
      })
    ];
  };
}
