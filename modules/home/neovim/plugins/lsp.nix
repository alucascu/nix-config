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
                expr = 'import (builtins.getflake "/home/alucascu/nixConfig").inputs.nixpkgs {}',
              },
              formatting = {
                command = { "alejandra" },
              },
            },
          },
        }
        return opts
      end,
    }
  '';
}
