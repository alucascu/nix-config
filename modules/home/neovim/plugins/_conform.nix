{
  programs.lazyvim.plugins.conform = ''
    return {
      "stevearc/conform.nvim",
      opts = function(_, opts)
        opts.formatters_by_ft = opts.formatters_by_ft or {}
        opts.formatters_by_ft.nix = { "alejandra" }
        opts.formatters_by_ft.python = {"ruff_format"}
        opts.formatters_by_ft.tex = { "tex-fmt" }
        opts.formatters_by_ft.plaintex = { "tex-fmt" }
        opts.formatters_by_ft.bib = { "tex-fmt" }
        return opts
      end,
    }
  '';
}
