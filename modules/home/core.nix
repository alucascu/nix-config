{...}: {
  flake.modules.homeManager.core = {pkgs, ...}: {
    home = {
      username = "alucascu";
      homeDirectory = "/home/alucascu";
      stateVersion = "25.11";

      sessionPath = ["/home/alucascu/.local/bin"];

      packages = with pkgs; [
        fastfetch
        home-manager

        # Secret management
        pass

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
        fx
        jaq

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

        glow
        btop
        iotop
        iftop

        strace
        ltrace
        lsof

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
    };
  };
}
