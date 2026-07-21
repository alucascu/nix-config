{
  flake.modules.homeManager.plasma = {pkgs, ...}: {
    home.packages = [
      pkgs.kde-gruvbox
      pkgs.plasma-panel-colorizer
    ];

    programs.plasma = {
      enable = true;

      workspace = {
        colorScheme = "GruvboxDark";
        iconTheme = "Papirus-Dark";
      };

      panels = [
        {
          location = "bottom";
          height = 44;
          floating = true;
          widgets = [
            {
              kickoff = {
                icon = "nix-snowflake-white";
                sortAlphabetically = true;
              };
            }
            {
              iconTasks.launchers = [
                "applications:kitty.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:obsidian.desktop"
                "applications:firefox.desktop"
              ];
            }
            "org.kde.plasma.marginsseparator"
            {plasmaPanelColorizer = {};}
            "org.kde.plasma.systemtray"
            {
              digitalClock = {
                time.format = "24h";
                date.enable = true;
              };
            }
          ];
        }
      ];

      configFile.kdeglobals.General.TerminalApplication = "kitty";
    };
  };
}
