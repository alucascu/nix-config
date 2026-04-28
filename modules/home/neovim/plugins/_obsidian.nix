{
  programs.lazyvim.plugins.obsidian = ''
    return {
      "epwalsh/obsidian.nvim",
      version = "*", -- pin whatever the latest release is
      lazy = true,
      ft = "markdown",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      opts = {
        workspaces = {
          {
            name = "School",
            path = "/home/asherl/Documents/School",
          },
        },
      },
    }
  '';
}
