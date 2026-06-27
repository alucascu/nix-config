{
  flake.modules.homeManager.mpv = {
    programs.mpv = {
      enable = true;
      config = {
        hwdec = "auto-safe";
        hwdec-codecs = "all";
        vo = "gpu-next";
        gpu-context = "x11egl";
      };
    };
  };
}
