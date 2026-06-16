{...}: {
  programs.lazyvim.config.autocmds =
    /*
    lua
    */
    ''
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      ls.add_snippets("markdown", {
        s("tree", {
          t({ "```", ".", "├── " }),
          i(1, "file"),
          t({ "", "└── " }),
          i(2, "file"),
          t({ "", "```" }),
        }),
      })
    '';
}
