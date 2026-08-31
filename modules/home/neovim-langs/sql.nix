{...}: {
  flake.modules.homeManager.neovim-sql = {
    key = "neovim-sql";

    programs.lazyvim.extras.lang.sql = {
      enable = true;
      installDependencies = true; # sqlfluff
    };
  };
}
