{inputs, ...}: {
  flake.modules.nixos.globalprotect = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.globalprotect-openconnect.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home-manager.sharedModules = [inputs.self.modules.homeManager.globalprotect];
  };

  flake.modules.homeManager.globalprotect = {
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.self.modules.homeManager.browser];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/globalprotectcallback" = "gpgui.desktop";
      };
    };

    programs.firefox.profiles.${config.myConfig.firefoxProfile}.settings = {
      "network.protocol-handler.expose.globalprotectcallback" = false;
      "network.protocol-handler.external.globalprotectcallback" = true;
      "network.protocol-handler.warn-external.globalprotectcallback" = false;
    };

    home.packages = [
      (pkgs.writeShellScriptBin "gp-callback" ''
        port=$(cat /tmp/gpcallback.port)
        printf '%s' "$1" | ${pkgs.netcat}/bin/nc -w1 127.0.0.1 "$port"
      '')
    ];

    home.shellAliases = {
      vpn = "sudo -E gpclient --fix-openssl --ignore-tls-errors connect --browser firefox gp2.northcrossgroup.com --as-gateway & disown";
      vpn-callback = "gp-callback";
      vpn-off = "sudo gpclient disconnect";
    };
  };
}
