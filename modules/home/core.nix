{...}: {
  flake.modules.homeManager.core = {
    config,
    pkgs,
    ...
  }: {
    home = {
      stateVersion = "25.11";

      sessionPath = ["${config.home.homeDirectory}/.local/bin"];

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
        fzf
        lazygit
        lazydocker
        gh
        direnv
        zoxide
        starship
        fx
        jaq
        tokei

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

        # Academic Writing (CLI)
        tectonic
        typst

        devenv
        python314
        proton-vpn-cli
        nodejs
        sqlite
        harlequin
        rclone

        jujutsu
      ];
    };
  };
}
