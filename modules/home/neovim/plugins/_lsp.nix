{
  programs.lazyvim.plugins.lsp-config = ''
    return {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
        opts.servers = opts.servers or {}
        opts.servers.pyright = { enabled = false }
        opts.servers.basedpyright = { enabled = false }
        opts.servers.pyrefly = {
          settings = {
            python = {
              pyrefly = {
                typeCheckingMode = "strict",
              },
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
              options = {
                nixos = {
                  expr = '(builtins.getFlake "/home/alucascu/nix-config").nixosConfigurations.hades.options',
                },
                home_manager = {
                  expr = '(builtins.getFlake "/home/alucascu/nix-config").nixosConfigurations.hades.options.home-manager.users.type.getSubOptions []',
                },
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
