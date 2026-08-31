{...}: {
  flake.modules.homeManager.neovim-toml = {
    key = "neovim-toml";

    programs.lazyvim.extras.lang.toml = {
      enable = true;
      installDependencies = true; # taplo
    };
  };
}
