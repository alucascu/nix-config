{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "Asher Lucas-Cuddeback";
          email = "alucascu@proton.me";
        };
        pull.ff = "only";
        rebase.autoStash = true;
        core.editor = "nvim";
        init.defaultBranch = "main";
        signing = {
          format = "gpg";
          signByDefault = true;
        };
      };

      ignores = [
        ".direnv"
        "*.DS_Store"
        "__pycache__"
        "CLAUDE.md"
        "AGENTS.md"
      ];
    };

    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        editor = "nvim";
      };
    };
  };
}
