{
  programs.lazyvim.plugins.colorscheme = ''
    return {
      {
        "rebelot/kanagawa.nvim",
        priority = 1001,
        opts = {
          theme = "dragon",
        },
      },
      {
        "neanias/everforest-nvim",
        priority = 1000,
      },
      {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        opts = {
          contrast = "hard", -- "", "soft", or "hard"
        },
      },
      {
        "LazyVim/LazyVim",
        opts = {
          colorscheme = "kanagawa-dragon",
        },
      },
    }
  '';
}
