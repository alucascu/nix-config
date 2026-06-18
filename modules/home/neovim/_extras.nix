{
  programs.lazyvim = {
    enable = true;
    extras = {
      editor = {
        aerial.enable = true;
      };

      util = {
        octo.enable = true;
      };

      lang = {
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

        typescript = {
          enable = true;
          installDependencies = true;
        };

        julia = {
          enable = true;
          installDependencies = true;
        };

        git = {
          enable = true;
        };

        markdown = {
          enable = true;
          installDependencies = true;
        };
      };
    };
  };
}
