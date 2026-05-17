{
  programs.lazyvim.enable = true;

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

    rust = {
      enable = true;
      installDependencies = true; # rust-analyzer
    };
    ocaml = {
      enable = true;
      installDependencies = true;
    };
    dotnet = {
      enable = true;
      installDependencies = true; # fantomas, fsautocomplete via Mason
    };
    toml = {
      enable = true;
      installDependencies = true;
    };
  };
}
