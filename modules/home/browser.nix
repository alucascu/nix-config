{
  flake.modules.homeManager.browser = {
    config,
    lib,
    ...
  }: {
    # Imported by `desktop`, `starttree` and `globalprotect`; a stable key lets
    # the module system dedupe those so the option is declared exactly once.
    key = "flake.modules.homeManager.browser";

    options = {
      myConfig.firefoxProfile = lib.mkOption {
        type = lib.types.str;
        default = "personal";
        description = "Firefox profile that browser-adjacent aspects write into.";
      };

      # Extends home-manager's profile submodule, so every profile -- personal
      # here, work from the `work` aspect -- starts from the same baseline.
      programs.firefox.profiles = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          settings = {
            "browser.startup.homepage" = lib.mkDefault "about:blank";
            "browser.newtabpage.enabled" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "dom.security.https_only_mode" = true;
            "security.enterprise_roots.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
        });
      };
    };

    config = {
      home.sessionVariables.BROWSER = "firefox";

      # Firefox rewrites profiles.ini on startup, so home-manager keeps finding
      # an unmanaged file where its symlink should be. See the note in `gtk` --
      # backupFileExtension only tolerates one such rewrite.
      home.file."${config.programs.firefox.configPath}/profiles.ini".force = true;

      xdg = {
        # Same story: anything that sets a default handler rewrites both copies
        # of mimeapps.list, and both are generated in full from mimeApps below.
        configFile."mimeapps.list".force = true;
        dataFile."applications/mimeapps.list".force = true;

        mimeApps = {
          enable = true;
          defaultApplications = {
            "text/html" = "firefox.desktop";
            "x-scheme-handler/http" = "firefox.desktop";
            "x-scheme-handler/https" = "firefox.desktop";
            "x-scheme-handler/about" = "firefox.desktop";
            "x-scheme-handler/unknown" = "firefox.desktop";
          };
        };
      };

      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        # The personal profile predates its name; `path` keeps it pointed at
        # the existing directory rather than starting a fresh one.
        profiles.${config.myConfig.firefoxProfile} = {
          id = 0;
          path = "alucascu";
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
