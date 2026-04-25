
{ 
  inputs,
  lib,
  config, 
  pkgs, 
  ...
}: {

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
  ];


  programs.fish = {
    enable = true;
  };
  
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github" = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        identityFile = "/home/alucascu/.ssh/hades";
      };
    };
  };

  programs.git = {
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

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    extraConfig = ''
      set-option -sa terminal-features ',kitty:RGB'
      set-option -g default-shell "${pkgs.fish}/bin/fish"
    '';
  };

  programs.kitty = {
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

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  programs.home-manager.enable = true;

  # Though shall not mess with
  home.stateVersion = "25.11";
}
