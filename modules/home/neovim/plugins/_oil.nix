{
  programs.lazyvim.plugins.oil = ''
    return {
      "stevearc/oil.nvim",
      lazy = false,
      opts = {
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 40,
        },
        use_default_keymaps = false,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = { "actions.select", opts = { vertical = true } },
          ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-r>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["g."] = "actions.toggle_hidden",
          ["gx"] = "actions.open_external",
        },
      },
      keys = {
        { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
        { "<leader>o", function() require("oil").toggle_float() end, desc = "Oil (float)" },
      },
    }
  '';
}
