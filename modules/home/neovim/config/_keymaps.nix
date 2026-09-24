{
  programs.lazyvim.config.keymaps = ''
    vim.keymap.set("i", "jj", "<Esc>",  {noremap = true, silent = true})
    vim.keymap.set("i", "|--", "├── ", { buffer = true })
    vim.keymap.set("i", "`--", "└── ", { buffer = true })
    vim.keymap.set("i", "|  ", "│   ", { buffer = true })

    -- Under vscode-neovim the LazyVim vscode extra disables the pickers, LSP
    -- keymaps, oil and aerial. Point their keys at the VSCode equivalents.
    if vim.g.vscode then
      local vscode = require("vscode")
      local function action(name)
        return function()
          vscode.action(name)
        end
      end

      for lhs, spec in pairs({
        ["-"] = { "workbench.files.action.showActiveFileInExplorer", "Reveal in Explorer" },
        ["<leader>e"] = { "workbench.view.explorer", "Explorer" },
        ["<leader>ff"] = { "workbench.action.quickOpen", "Find Files" },
        ["<leader>cr"] = { "editor.action.rename", "Rename" },
        ["<leader>ca"] = { "editor.action.quickFix", "Code Action" },
        ["<leader>cf"] = { "editor.action.formatDocument", "Format" },
        ["<leader>cs"] = { "outline.focus", "Symbols (Outline)" },
      }) do
        vim.keymap.set("n", lhs, action(spec[1]), { desc = spec[2] })
      end
    end
  '';
}
