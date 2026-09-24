{...}: {
  flake.modules.homeManager.neovim-python = {
    key = "neovim-python";

    imports = [
      ({pkgs, ...}: {
        programs.lazyvim.extras.lang.python = {
          enable = true;
          installDependencies = true; # python3Packages.ruff
        };

        programs.lazyvim.extraPackages = with pkgs; [
          ruff
          pyrefly
        ];
      })
    ];
  };
}
