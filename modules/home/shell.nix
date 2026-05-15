{...}: {
  flake.modules.homeManager.shell = {pkgs, ...}: {
    programs = {
      fish.enable = true;

      starship = {
        enable = true;
        enableFishIntegration = true;
      };

      zoxide = {
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


          ## Color
          set -g default-terminal "tmux-256color"
        '';
      };

      home-manager.enable = true;
    };
  };
}
