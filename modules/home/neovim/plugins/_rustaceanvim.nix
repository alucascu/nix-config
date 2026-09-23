{
  programs.lazyvim.plugins.rustaceanvim = ''
    return {
      "mrcjkb/rustaceanvim",
      optional = true,
      opts = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              lens = {
                implementations = { enable = false },
              },
            },
          },
        },
      },
    }
  '';
}
