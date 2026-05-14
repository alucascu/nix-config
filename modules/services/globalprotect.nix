{inputs, ...}: {
  flake.modules.nixos.globalprotect = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.globalprotect-openconnect.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.mime.defaultApplications = {
      "x-scheme-handler/globalprotectcallback" = "gpgui.desktop";
    };
  };

  flake.modules.homeManager.globalprotect = {pkgs, ...}: {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/globalprotectcallback" = "gpgui.desktop";
      };
    };

    home.packages = [
      (pkgs.writeShellScriptBin "gp-callback" ''
        port=$(cat /tmp/gpcallback.port)
        printf '%s' "$1" | ${pkgs.netcat}/bin/nc -w1 127.0.0.1 "$port"
      '')
    ];

    home.shellAliases = {
      vpn = "sudo -E gpclient --fix-openssl --ignore-tls-errors connect --browser firefox gp2.northcrossgroup.com & disown";
      vpn-callback = "gp-callback";
      vpn-off = "sudo gpclient disconnect";
    };
  };
}
