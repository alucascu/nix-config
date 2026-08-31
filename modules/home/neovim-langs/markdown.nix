{...}: {
  flake.modules.homeManager.neovim-markdown = {
    key = "neovim-markdown";

    programs.lazyvim.extras.lang.markdown = {
      enable = true;
      installDependencies = true; # markdownlint-cli2, markdown-toc
    };
  };
}
