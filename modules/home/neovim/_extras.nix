{
  # Editor-level extras only. Everything language-specific lives in its own
  # aspect under modules/home/neovim-langs/.
  programs.lazyvim = {
    enable = true;

    extras = {
      coding.mini-surround.enable = true;
      dap.core.enable = true;

      editor = {
        aerial.enable = true;
        harpoon2.enable = true;
        inc-rename.enable = true;
      };

      test.core.enable = true;

      util = {
        mini-hipatterns.enable = true;
        octo.enable = true;
      };
    };
  };
}
