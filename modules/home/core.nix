{...}: {
  flake.modules.homeManager.core = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home = {
      stateVersion = "25.11";

      sessionPath = ["${config.home.homeDirectory}/.local/bin"];

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        # :Man! renders the page in the current window instead of a split.
        MANPAGER = "nvim +Man!";
        PAGER = "less";
        LESS = "-R";
      };

      # programs.home-manager installs the CLI only when home-manager runs
      # standalone (it is guarded on !submoduleSupport.enable), so under the
      # NixOS module nothing else provides it. Add it exactly where it is
      # missing — installing it unconditionally collides with the version-matched
      # copy in the standalone profile.
      packages =
        lib.optional
        (!(config.programs.home-manager.enable && !config.submoduleSupport.enable))
        pkgs.home-manager
        ++ (with pkgs; [
          fastfetch

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
        ]);
    };
  };
}
