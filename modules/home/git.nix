{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Asher Lucas-Cuddeback";
        email = "alucascu@proton.me";
      };
      core.editor = "nvim";
      init.defaultBranch = "main";
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
}
