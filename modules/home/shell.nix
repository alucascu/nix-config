{pkgs, ...}: {
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
      extraConfig = ''
        set-option -sa terminal-features ',kitty:RGB'
        set-option -g default-shell "${pkgs.fish}/bin/fish"
      '';
    };

    home-manager.enable = true;
  };
}
