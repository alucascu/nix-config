{
  flake.modules.homeManager.shell = {pkgs, ...}: {
    # config.fish is generated here in full. Anything that appends to it -- an
    # installer, a hand-run `fish_add_path` -- turns it into a real file, and
    # activation then fails on the next rebuild once a .bak already exists.
    xdg.configFile."fish/config.fish".force = true;

    programs = {
      fish = {
        enable = true;
        plugins = [];
        interactiveShellInit = ''
          ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
        '';
      };

      eza = {
        enable = true;
        enableFishIntegration = true;
        git = true;
        icons = "auto";
      };

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
        silent = true;
      };

      tmux = {
        enable = true;
        mouse = true;
        keyMode = "vi";
        focusEvents = true;
        aggressiveResize = true;

        plugins = with pkgs.tmuxPlugins; [
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-capture-pane-contents 'on'
              set -g @resurrect-strategy-nvim 'session'
            '';
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '15'
            '';
          }
        ];

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
