{
  flake.modules.homeManager.terminal = {
    programs.kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      themeFile = "GruvboxMaterialDarkHard";

      font = {
        name = "Lilex Nerd Font";
        size = 14.0;
      };

      settings = {
        scrollback_lines = 10000;
        background_opacity = "0.9";
        linux_display_server = "auto";
        dynamic_background_opacity = true;
        cursor_trail = 1;
        enable_audio_bell = false;
        window_padding_width = 4;
        confirm_os_window_close = 0;
        shell = "fish";
        disable_ligatures = "never";
      };
    };
  };
}
