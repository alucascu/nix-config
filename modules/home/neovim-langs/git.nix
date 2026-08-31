{...}: {
  # Plugins only — the extra maps no packages, and git itself is a core
  # dependency lazyvim-nix installs regardless.
  flake.modules.homeManager.neovim-git = {
    key = "neovim-git";

    programs.lazyvim.extras.lang.git.enable = true;
  };
}
