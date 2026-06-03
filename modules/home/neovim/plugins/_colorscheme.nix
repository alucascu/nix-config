{
  programs.lazyvim.plugins.colorscheme = ''
    return {
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
          colorscheme = "gruvbox",
        },
      },
    }
  '';
}
