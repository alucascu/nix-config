{
  lib,
  pkgs,
  ...
}: let
  lsp = import ../../_lsp-settings.nix {inherit lib pkgs;};
  toLua = lib.generators.toLua {multiline = false;};
in {
  programs.lazyvim.plugins.lsp-config = ''
    return {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
        opts.servers = opts.servers or {}
        opts.servers.pyright = { enabled = false }
        opts.servers.basedpyright = { enabled = false }
        opts.servers.pyrefly = ${toLua {settings.python.pyrefly = lsp.pyrefly;}}
        opts.servers.nil_ls = { enabled = false }
        opts.servers.nixd = ${toLua {settings.nixd = lsp.nixd;}}
        opts.servers.ocamllsp = {
          settings = {
            ocamllsp = {
              codelens = { enable = true },
              inlayHints = {
                enable = true,
                hintLetBindings = true,
                hintPatternVariables = true,
                hintFunctionParams = true,
              },
              extendedHover = { enable = true },
              syntaxDocumentation = { enable = true },
            },
          },
        }
        opts.servers.ltex_plus = {
          settings = {
            ltex = {
              language = "en-US",
            },
          },
        }
        return opts
      end,
    }
  '';
}
