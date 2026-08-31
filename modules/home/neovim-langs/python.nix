{...}: {
  flake.modules.homeManager.neovim-python = {
    key = "neovim-python";

    imports = [
      ({pkgs, ...}: {
        programs.lazyvim.extras.lang.python = {
          enable = true;
          installDependencies = true; # python3Packages.ruff
        };

        # pyrefly and basedpyright have no mapping in the extra; ruff is
        # listed here as the standalone binary rather than the python module.
        programs.lazyvim.extraPackages = with pkgs; [
          ruff
          pyrefly
          basedpyright
        ];
      })
    ];
  };
}
