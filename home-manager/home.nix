{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.lazyvim.homeManagerModules.default];

  nixpkgs = {
    overlays = [];

    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "alucascu";
    homeDirectory = "/home/alucascu";
  };

  home.packages = with pkgs; [
    fastfetch

    # Archives
    zip
    xz
    unzip
    p7zip

    # CLI Utilities
    ripgrep
    eza
    fzf
    lazygit
    lazydocker
    gh
    direnv
    zoxide
    starship

    # Databases
    mysql-workbench

    # Misc
    file
    which
    tree
    gnutar
    gnused
    gawk
    zstd
    gnupg
    opencode
    claude-code

    fish

    glow # Markdown previewer
    btop
    iotop
    iftop

    strace # System call monitoring
    ltrace # Library call monitoring
    lsof # List open files

    # System tools
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # Academic Writing
    tectonic
    typst
    zathura

    # Fonts
    nerd-fonts.lilex

    devenv

    obsidian

    signal-desktop
  ];

  programs = {
    fish = {
      enable = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
        "github" = {
          host = "github.com";
          hostname = "github.com";
          user = "git";
          identityFile = "/home/alucascu/.ssh/hades";
        };
      };
    };

    lazyvim = {
      enable = true;

      extras = {
        lang = {
          nix.enable = true;

          python = {
            enable = true;
            installDependencies = true;
          };

          tex = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };

          haskell = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };
      };

      extraPackages = with pkgs; [
        nixd
        nixfmt
        alejandra
        statix
        ty
        pplatex
      ];

      plugins = {
        lsp-config = ''
          return {
            "neovim/nvim-lspconfig",
            opts = function(_, opts)
              opts.servers = opts.servers or {}
              opts.servers.nil_ls = { enabled = false }
              opts.servers.nixd = {
                settings = {
                  nixd = {
                    nixpkgs = {
                      expr = 'import (builtins.getflake "/home/alucascu/nixconfig").inputs.nixpkgs {}',
                    },
                    formatting = {
                      command = { "alejandra" },
                    },
                  },
                },
              }
              return opts
            end,
          }
        '';
        conform = ''
          return {
            "stevearc/conform.nvim",
            opts = function(_, opts)
              opts.formatters_by_ft = opts.formatters_by_ft or {}
              opts.formatters_by_ft.nix = { "alejandra" }
              return opts
            end,
          }
        '';
      };
    };

    git = {
      enable = true;

      settings = {
        user = {
          name = "Asher Lucas-Cuddeback";
          email = "alucascu@proton.me";
        };
        core.editor = "nvim";
        init.defaultBranch = "main";
      };

      ignores = [
        ".direnv"
        "*.DS_Store"
        "__pycache__"
        "CLAUDE.md"
        "AGENTS.md"
      ];
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        editor = "nvim";
      };
    };

    tmux = {
      enable = true;
      mouse = true;
      extraConfig = ''
        set-option -sa terminal-features ',kitty:RGB'
        set-option -g default-shell "${pkgs.fish}/bin/fish"
      '';
    };

    kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      themeFile = "GruvboxMaterialDarkHard";

      font = {
        name = "Lilex Nerd Font";
        size = 14.0;
      };

      settings = {
        scrollback_lines = 10000;
        background_opacity = "0.9";
        linux_display_server = "auto";
        dynamic_background_opacity = true;
        cursor_trail = 1;
        enable_audio_bell = false;
        window_padding_width = 4;
        confirm_os_window_close = 0;
        shell = "fish";
        disable_ligatures = "never";
      };
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home-manager.enable = true;
  };

  home.sessionPath = [
    "/home/alucascu/.local/bin"
  ];

  # Though shall not mess with
  home.stateVersion = "25.11";
}
