{
  flake.modules.homeManager.shell = {
    lib,
    pkgs,
    ...
  }: {
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
        enableTransience = true;

        settings = {
          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$directory"
            "$git_branch"
            "$git_state"
            "$git_status"
            "$line_break"
            "$status"
            "$character"
          ];

          right_format = lib.concatStrings [
            "$nix_shell"
            "$direnv"
            "$cmd_duration"
          ];

          # GruvboxMaterialDarkHard, the same theme kitty is set to in
          # `terminal`. Referenced by name from the styles below.
          palette = "gruvbox";
          palettes.gruvbox = {
            fg = "#d4be98";
            gray = "#928374";
            red = "#ea6962";
            orange = "#e78a4e";
            yellow = "#d8a657";
            green = "#a9b665";
            aqua = "#89b482";
            blue = "#7daea3";
            purple = "#d3869b";
          };

          username = {
            format = "[$user]($style)[@](gray)";
            style_user = "bold purple";
            style_root = "bold red";
          };

          hostname = {
            ssh_only = true;
            format = "[$hostname]($style) ";
            style = "bold red";
          };

          directory = {
            truncation_length = 5;
            style = "bold blue";
            repo_root_style = "bold aqua";
          };

          git_branch = {
            format = "[$symbol$branch]($style) ";
            symbol = " ";
            style = "bold purple";
          };

          git_state.style = "bold orange";

          git_status = {
            style = "bold yellow";
            conflicted = "=$count";
            ahead = "⇡$count";
            behind = "⇣$count";
            diverged = "⇡$ahead_count⇣$behind_count";
            up_to_date = "";
            untracked = "?$count";
            stashed = "*$count";
            modified = "!$count";
            staged = "+$count";
            renamed = "»$count";
            deleted = "✘$count";
          };

          status = {
            disabled = false;
            format = "[$symbol$status]($style) ";
            style = "bold red";
            map_symbol = true;
            pipestatus = true;
            symbol = "✘ ";
            not_executable_symbol = "✘ ";
            not_found_symbol = "? ";
            signal_symbol = "⚡ ";
            sigint_symbol = "⚡ ";
          };

          character = {
            success_symbol = "[❯](bold green)";
            error_symbol = "[❯](bold red)";
            vicmd_symbol = "[❮](bold yellow)";
          };

          direnv = {
            disabled = false;
            format = "[$symbol$loaded$allowed]($style) ";
            symbol = " ";
            style = "bold green";
            loaded_msg = "";
            unloaded_msg = "off";
            allowed_msg = "";
            not_allowed_msg = " needs allow";
            denied_msg = " denied";
          };

          nix_shell = {
            heuristic = true;
            symbol = "󱄅 ";
            format = "[$symbol$state]($style) ";
            style = "bold blue";
            impure_msg = "impure";
            pure_msg = "pure";
            unknown_msg = "shell";
          };

          cmd_duration = {
            min_time = 2000;
            show_notifications = true;
            min_time_to_notify = 30000;
            format = "[ $duration]($style) ";
            style = "bold yellow";
          };
        };
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
