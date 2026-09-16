{
  config,
  lib,
  ...
}: {
  home.activation.dropNvimLuacCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run rm -rf $VERBOSE_ARG ${lib.escapeShellArg "${config.xdg.cacheHome}/nvim/luac"}
  '';
}
