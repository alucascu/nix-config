{
  programs.lazyvim.plugins.lsp-config = ''
    return {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
        opts.servers = opts.servers or {}
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
        opts.servers.ty = {
          settings = {
            ty = {
              diagnosticMode = "workspace",
            },
          },
        }
        opts.servers.basedpyright = {
          settings = {
            basedpyright = {
              typeCheckingMode = "off",
              disableOrganizeImports = true,
              disableTaggedHints = true,
            },
          },
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = false,
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
        return opts
      end,
    }
  '';
}
