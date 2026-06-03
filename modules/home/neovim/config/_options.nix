{
  programs.lazyvim.config = {
    options = ''
      vim.g.lazyvim_python_lsp = "ty";
    '';

    autocmds = ''
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end
        end,
      })
    '';
  };
}
