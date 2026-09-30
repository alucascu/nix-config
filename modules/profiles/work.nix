{inputs, ...}: {
  flake.modules.nixos.work = {
    imports = with inputs.self.modules.nixos; [
      chromium
      globalprotect
    ];

    home-manager.sharedModules = [inputs.self.modules.homeManager.work];
  };

  flake.modules.homeManager.work = {pkgs, ...}: let
    # Its own app_id, so the work window groups and pins separately from the
    # personal one in the taskbar.
    firefox-work = pkgs.writeShellScriptBin "firefox-work" ''
      exec firefox -P work --name firefox-work "$@"
    '';
  in {
    imports = [inputs.self.modules.homeManager.browser];

    home.packages = with pkgs; [
      slack
      zoom-us
      firefox-work
    ];

    programs.firefox.profiles.work = {
      id = 1;
      settings = {
        "browser.startup.page" = 1; # the homepage list below
        "browser.startup.homepage" = "https://teams.cloud.microsoft|https://outlook.cloud.microsoft";
        "browser.toolbars.bookmarks.visibility" = "always";
      };
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Work";
            toolbar = true;
            bookmarks = [
              {
                name = "Jira";
                url = "https://ncgdev.atlassian.net";
              }
              {
                name = "GitHub NCG";
                url = "https://github.com/NorthcrossGroup";
              }
              {
                name = "Outlook";
                url = "https://outlook.cloud.microsoft";
              }
              {
                name = "Teams";
                url = "https://teams.cloud.microsoft";
              }
            ];
          }
        ];
      };
    };

    xdg.desktopEntries.firefox-work = {
      name = "Firefox (Work)";
      genericName = "Web Browser";
      exec = "${firefox-work}/bin/firefox-work %U";
      icon = "firefox";
      categories = ["Network" "WebBrowser"];
      settings.StartupWMClass = "firefox-work";
    };
  };
}
