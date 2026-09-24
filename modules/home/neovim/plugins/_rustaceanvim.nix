{
  lib,
  pkgs,
  ...
}: let
  lsp = import ../../_lsp-settings.nix {inherit lib pkgs;};
in {
  programs.lazyvim.plugins.rustaceanvim = ''
    return {
      "mrcjkb/rustaceanvim",
      optional = true,
      opts = {
        server = {
          default_settings = ${lib.generators.toLua {multiline = false;} {"rust-analyzer" = lsp.rust-analyzer;}},
        },
      },
    }
  '';
}
