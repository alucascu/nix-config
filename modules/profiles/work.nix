{inputs, ...}: {
  flake.modules.nixos.work = {
    imports = with inputs.self.modules.nixos; [
      chromium
      globalprotect
    ];
  };
  flake.modules.homeManager.work = {config, ...}: {
    imports = with inputs.self.modules.homeManager; [];

    programs.chromium = {
      enable = true;
      commandLineArgs = [
        "--profile-directory=work"
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
      ];
    };

    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      profiles.default = {
        settings = {
          "network.protocol-handler.expose.globalprotectcallback" = false;
          "network.protocol-handler.external.globalprotectcallback" = true;
          "network.protocol-handler.warn-external.globalprotectcallback" = false;
        };
      };
    };

    xdg.desktopEntries.gpclient = {
      name = "GlobalProtect";
      exec = "gpclient callback %u";
      noDisplay = true;
      mimeType = ["x-scheme-handler/globalprotectcallback"];
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/globalprotectcallback" = "gpclient.desktop";
      };
    };

    home.shellAliases = {
      vpn = "sudo -E gpclient --fix-openssl --ignore-tls-errors connect --browser firefox gp2.northcrossgroup.com";
      vpn-off = "sudo gpclient disconnect";
    };
  };
}
