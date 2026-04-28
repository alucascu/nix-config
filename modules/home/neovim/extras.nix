{
  programs.lazyvim.extras.lang = {
    nix.enable = true;

    python = {
      enable = true;
      installDependencies = true;
    };

    tex = {
      enable = true;
      installDependencies = true;
      installRuntimeDependencies = true;
    };

    haskell = {
      enable = true;
      installDependencies = true;
      installRuntimeDependencies = true;
    };
  };
}
