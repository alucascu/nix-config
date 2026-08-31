{...}: {
  # Free: plugins and treesitter parsers only. The extra maps no packages,
  # and the Julia toolchain itself is expected on PATH from elsewhere.
  flake.modules.homeManager.neovim-julia = {
    key = "neovim-julia";

    programs.lazyvim.extras.lang.julia.enable = true;
  };
}
