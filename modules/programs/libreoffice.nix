{pkgs, ...}: {
  flake.modules.nixos.chromium = {pkgs, ...}: {
    programs.chromium = {
      enable = true;

      extraOpts = {
        # Enforce a dedicated profile directory so it never touches
        # the default profile shared with any other Chromium instance.
        "ProfileDirectory" = "work";

        # Disable the built-in password manager — use a proper vault.
        "PasswordManagerEnabled" = false;

        # Suppress the "save password?" bubble entirely.
        "PasswordManagerBlocklistDomains" = [];

        # Keep the work context visually distinct.
        "NewTabPageLocation" = "about:blank";

        "RestoreOnStartup" = 4;
        "RestoreOnStartupURLs" = [
          "https://github.com/NorthcrossGroup"
          "https://teams.cloud.microsoft"
          "https://outlook.cloud.microsoft"
        ];

        "ManagedBookmarks" = [
          {"toplevel_name" = "Work";}
          {
            "name" = "Jira";
            "url" = "https://ncgdev.atlassian.net";
          }
          {
            "name" = "GitHub NCG";
            "url" = "https://github.com/NorthcrossGroup";
          }
          {
            "name" = "Outlook";
            "url" = "https://outlook.cloud.microsoft";
          }
          {
            "name" = "Teams";
            "url" = "https://teams.cloud.microsoft";
          }
        ];
      };
    };

    # Dedicated launcher so it always opens into the work profile.
    environment.systemPackages = [
      (pkgs.makeDesktopItem {
        name = "chromium-work";
        desktopName = "Chromium (Work)";
        genericName = "Web Browser";
        exec = "${pkgs.chromium}/bin/chromium --profile-directory=work %U --enable-features=WebUIDarkMode --force-dark-mode";
        icon = "chromium";
        categories = ["Network" "WebBrowser"];
        comment = "Chromium locked to the work profile";
      })
    ];
  };
}
