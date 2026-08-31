{
  # Editor-level extras only. Everything language-specific lives in its own
  # aspect under modules/home/neovim-langs/.
  programs.lazyvim = {
    enable = true;

    extras = {
      dap.core.enable = true;
      editor.aerial.enable = true;
      util.octo.enable = true;
    };
  };
}
