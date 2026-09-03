{
  flake.modules.homeManager.desktop-apps = {pkgs, ...}: {
    home.packages = with pkgs; [
      # Fonts
      nerd-fonts.lilex

      # Academic (GUI)
      zathura
      zotero

      # Desktop applications
      obsidian
      signal-desktop
      teams-for-linux
      thunderbird
      protonmail-bridge-gui
      qbittorrent
      onlyoffice-desktopeditors
      sone

      anki
    ];
  };
}
