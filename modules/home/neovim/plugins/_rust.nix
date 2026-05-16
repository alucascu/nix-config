{
  programs.lazyvim.plugins.rust = ''
    return {
      "mrcjkb/rustaceanvim",
      version = "^6",
      lazy = false,
      opts = {
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, { silent = true, buffer = bufnr, desc = "Code Action" })
            vim.keymap.set("n", "K", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, { silent = true, buffer = bufnr, desc = "Hover" })
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            },
          },
        },
      },
    }
  '';
}
