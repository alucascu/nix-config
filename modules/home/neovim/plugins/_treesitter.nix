{ pkgs, inputs, ... }:
let
  corollaryGrammar = pkgs.tree-sitter.buildGrammar {
    language = "corollary";
    version = "0.1.0";
    src = inputs.corollary-tree-sitter;
  };

  corollaryPlugin = pkgs.runCommand "treesitter-grammar-corollary" {
    passthru = {
      grammar = corollaryGrammar;
      grammarName = "corollary";
    };
  } ''
    mkdir -p $out/parser $out/queries/corollary
    ln -s ${corollaryGrammar}/parser $out/parser/corollary.so
    cp ${inputs.corollary-tree-sitter}/queries/highlights.scm $out/queries/corollary/highlights.scm
    cp ${inputs.corollary-tree-sitter}/queries/locals.scm $out/queries/corollary/locals.scm
  '';
in {
  programs.lazyvim.plugins."corollary" = ''
    vim.filetype.add({ extension = { corollary = "corollary" } })

    return {
      {
        dir = "${corollaryPlugin}",
        name = "corollary-treesitter",
        lazy = false,
      },
      {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
          require("nvim-treesitter.parsers").get_parser_configs().corollary = {
            install_info = { url = ".", files = { "src/parser.c" } },
            filetype = "corollary",
          }
          return opts or {}
        end,
      },
    }
  '';
}
