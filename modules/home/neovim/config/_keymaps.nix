{
  programs.lazyvim.config.keymaps = ''
    vim.keymap.set("i", "jj", "<Esc>",  {noremap = true, silent = true})
    vim.keymap.set("i", "|--", "├── ", { buffer = true })
    vim.keymap.set("i", "`--", "└── ", { buffer = true })
    vim.keymap.set("i", "|  ", "│   ", { buffer = true })
  '';
}
