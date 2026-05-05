{...}: {
  flake.modules.homeManager.shell = {pkgs, ...}: {
    programs = {
      fish.enable = true;

      starship = {
        enable = true;
        enableFishIntegration = true;
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      tmux = {
        enable = true;
        mouse = true;
        keyMode = "vi";
        extraConfig = ''
          set-option -sa terminal-features ',kitty:RGB'
          set-option -g default-shell "${pkgs.fish}/bin/fish"

          # Vim-Style Usage
          ## Splits
          bind v split-window -h -c "#{pane_current_path}"
          bind s split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          ## Pane navigation (vim-style)
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          ## Pane resizing
          bind -r H resize-pane -L 5
          bind -r J resize-pane -D 5
          bind -r K resize-pane -U 5
          bind -r L resize-pane -R 5

          # Aesthetics
          ## Cursor
          cursor_shape block
          cursor_blink_interval 0

          ## Font rendering
          font_features LilexNerdFont-Regular +ss01  # optional stylistic sets
          adjust_line_height 0
          adjust_column_width 0

          ## Color precision
          color_scheme_preference dark

          ## Undercurl support (Neovim uses this for diagnostics)
          undercurl_style thin-sparse

          ## Color
          term xterm-256color
        '';
      };

      home-manager.enable = true;
    };
  };
}
