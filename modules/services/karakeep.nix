{
  flake.modules.nixos.karakeep = {
    services.karakeep = {
      enable = true;
      meilisearch.enable = true;
      browser.enable = true;

      extraEnvironment = {
        DISABLE_NEW_RELEASE_CHECK = "true";

        # Bind only to loopback — Caddy proxies in from outside
        HOSTNAME = "127.0.0.1";
      };
    };

    services.caddy.virtualHosts."http://karakeep.lan" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:3000
      '';
    };
  };
}
