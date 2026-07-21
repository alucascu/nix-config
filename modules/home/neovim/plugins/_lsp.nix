{
  programs.lazyvim.plugins.lsp-config = ''
    return {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
        opts.servers = opts.servers or {}
        opts.servers.pyright = {enabled = false}
        opts.servers.basedpyright = {
          settings = {
            basedpyright = {
              typeCheckingMode = "strict",
              reportUnknownMemberType = false,
              reportUnknownVariableType = false,
              reportUnknownArgumentType = false,
            },
          },
        }
        opts.servers.nil_ls = { enabled = false }
        opts.servers.nixd = {
          settings = {
            nixd = {
              nixpkgs = {
                expr = 'import (builtins.getflake "/home/alucascu/nix-config").inputs.nixpkgs {}',
              },
              formatting = {
                command = { "alejandra" },
              },
            },
          },
        }
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
