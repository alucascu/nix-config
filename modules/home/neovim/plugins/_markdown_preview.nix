{
  programs.lazyvim.plugins."markdown-preview" = ''
    return {
      "iamcco/markdown-preview.nvim",
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
