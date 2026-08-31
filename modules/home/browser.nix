{
  flake.modules.homeManager.browser = {
    config,
    lib,
    ...
  }: {
    # Imported by `desktop`, `starttree` and `globalprotect`; a stable key lets
    # the module system dedupe those so the option is declared exactly once.
    key = "flake.modules.homeManager.browser";

    options.myConfig.firefoxProfile = lib.mkOption {
      type = lib.types.str;
      default = "alucascu";
      description = "Firefox profile that browser-adjacent aspects write into.";
    };

    config = {
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
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        profiles.${config.myConfig.firefoxProfile} = {
          isDefault = true;
          id = 0;
          settings = {
            "browser.startup.homepage" = lib.mkDefault "about:blank";
            "browser.newtabpage.enabled" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "dom.security.https_only_mode" = true;
            "privacy.trackingprotection.enabled" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
        };

        policies = {
          EnableTrackingProtection = {
            Value = true;
            Cryptomining = true;
            Fingerprinting = true;
            Exceptions = [
              "https://outlook.cloud.microsoft"
              "https://teams.cloud.microsoft"
            ];
          };
        };
      };
    };
  };
}
