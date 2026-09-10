{
  flake.modules.homeManager.terminal = {pkgs, ...}: {
    programs.kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      enableGitIntegration = true;
      themeFile = "GruvboxMaterialDarkHard";

      font = {
        name = "Lilex Nerd Font";
        size = 14.0;
      };

      settings = {
        shell = "${pkgs.fish}/bin/fish";
        scrollback_lines = 10000;
        background_opacity = "0.9";
        linux_display_server = "auto";
        dynamic_background_opacity = true;
        cursor_trail = 1;
        enable_audio_bell = false;
        window_padding_width = 4;
        confirm_os_window_close = 0;
        disable_ligatures = "never";
        auto_reload_config = -1;
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
      };

      keybindings = {
        # kitty's own defaults for these three open in $HOME.
        "ctrl+shift+enter" = "new_window_with_cwd";
        "ctrl+shift+t" = "new_tab_with_cwd";
        "ctrl+shift+n" = "new_os_window_with_cwd";

        # Font size on the bare ctrl chord, alongside kitty's ctrl+shift default.
        "ctrl+equal" = "change_font_size all +1.0";
        "ctrl+plus" = "change_font_size all +1.0";
        "ctrl+minus" = "change_font_size all -1.0";
        "ctrl+0" = "change_font_size all 0";
      };
    };
  };
}
