{
  programs.lazyvim.plugins.blink-luasnip = ''
    return {
      "saghen/blink.cmp",
      opts = {
        snippets = {
          preset = "luasnip",
        },
      },
    }
  '';
}
