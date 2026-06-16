{
  programs.lazyvim.config = {
    autocmds = ''
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true)
            end
            if client.server_capabilities.codeLensProvider then
              vim.lsp.codelens.refresh()
              vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost' }, {
                buffer = args.buf,
                callback = vim.lsp.codelens.refresh,
              })
            end
          end,
        })

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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("i", "|--", "├── ", { buffer = true })
          vim.keymap.set("i", "`--", "└── ", { buffer = true })
          vim.keymap.set("i", "|  ", "│   ", { buffer = true })
        end,
      })
    '';
  };
}
