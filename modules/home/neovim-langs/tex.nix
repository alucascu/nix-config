{...}: {
  # ~0.9 GB, nearly all of it the JVM behind ltex-ls-plus.
  #
  # `installDependencies` stays off: the extra's only tool is pplatex, which
  # has no nixpkgs mapping upstream, so enabling it would emit a warning on
  # every build and install nothing. pplatex is in nixpkgs under that name,
  # so it is listed directly.
  flake.modules.homeManager.neovim-tex = {
    key = "neovim-tex";

    imports = [
      ({pkgs, ...}: {
        programs.lazyvim.extras.lang.tex.enable = true;

        programs.lazyvim.extraPackages = with pkgs; [
          pplatex
          ltex-ls-plus
          tex-fmt
        ];
      })
    ];
  };
}
