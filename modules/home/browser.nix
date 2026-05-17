{
  flake.modules.homeManager.browser = {
    home.sessionVariables.BROWSER = "firefox";

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };

    programs.firefox = {
      enable = true;
      profiles.alucascu = {
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "about:blank";
          "browser.newtabpage.enabled" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "dom.security.https_only_mode" = true;
          "privacy.trackingprotection.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };

    programs.chromium = {
      commandLineArgs = [
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
      ];
    };
  };
}
