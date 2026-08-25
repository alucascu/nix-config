{
  flake.modules.homeManager.desktop-apps = {pkgs, ...}: {
    home.packages = with pkgs; [
      # Encryption (GUI)
      veracrypt

      # Fonts
      nerd-fonts.lilex

      # Academic (GUI)
      zathura
      zotero

      # Desktop applications
      obsidian
      signal-desktop
      chromium
      teams-for-linux
      thunderbird
      protonmail-bridge-gui
      digikam
      qbittorrent
      megasync
      onlyoffice-desktopeditors
      gitify
      jetbrains.pycharm

      anki
    ];
  };
}
