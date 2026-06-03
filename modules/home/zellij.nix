{...}: {
  flake.modules.homeManager.zellij = {...}: {
    programs.zellij = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        # Start in normal mode instead of locked
        default_mode = "normal";

        # Use fish as the default shell
        default_shell = "fish";

        # Scroll speed
        scroll_buffer_size = 10000;

        # Theme — gruvbox-dark ships with zellij by default
        theme = "gruvbox-dark";

        # Copy on select (wayland)
        copy_on_select = true;
        copy_command = "wl-copy";

        # Keep pane name visible
        pane_frames = true;

        # Session serialization so sessions survive reboots
        session_serialization = true;
      };
    };
  };
}
