{
  flake.modules.homeManager.desktop-apps = {pkgs, ...}: let
    signal-desktop-kwallet = pkgs.symlinkJoin {
      name = "signal-desktop-kwallet";
      paths = [pkgs.signal-desktop];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/signal-desktop --add-flags "--password-store=kwallet6"
      '';
    };
  in {
    home.packages = with pkgs; [
      # Academic (GUI)
      zathura
      zotero

      # Desktop applications
      obsidian
      signal-desktop-kwallet
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
