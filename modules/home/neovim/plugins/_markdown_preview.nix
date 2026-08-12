{pkgs, ...}: {
  programs.lazyvim.plugins."markdown-preview" = ''
    return {
      dir = "${pkgs.vimPlugins.markdown-preview-nvim}",
      name = "markdown-preview.nvim",
      lazy = true,
      ft = { "markdown" },
      cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
      init = function()
        vim.g.mkdp_auto_close = 1
        vim.g.mkdp_theme = "dark"
      end,
      keys = {
        { "<leader>mp", "<CMD>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Markdown Preview (toggle)" },
      },
    }
  '';
}
