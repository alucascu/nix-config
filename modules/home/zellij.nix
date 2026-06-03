{...}: {
  flake.modules.homeManager.zellij = {pkgs, ...}: {
    programs.zellij = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        default_mode = "normal";
        default_shell = "fish";
        scroll_buffer_size = 10000;
        theme = "gruvbox-dark";
        copy_on_select = true;
        copy_command = "${pkgs.wl-clipboard}/bin/wl-copy";
        pane_frames = true;
        session_serialization = true;
      };
    };
  };
}
