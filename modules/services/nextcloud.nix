{
  flake.modules.nixos.nextcloud = {
    config,
    inputs,
    pkgs,
    ...
  }: {
    imports = [inputs.self.modules.nixos.caddy];

    age.secrets.nextcloud-admin-password = {
      file = ../../secrets/nextcloud-admin-password.age;
      owner = "nextcloud";
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud34;
      hostName = "cloud.tantalus.lan";
      https = true;
      maxUploadSize = "4G";
      configureRedis = true;
      database.createLocally = true;

      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) calendar contacts tasks;
      };
      extraAppsEnable = true;

      config = {
        dbtype = "pgsql";
        adminuser = "alucascu";
        adminpassFile = config.age.secrets.nextcloud-admin-password.path;
      };

      settings = {
        trusted_proxies = ["127.0.0.1" "::1"];
        overwriteprotocol = "https";
        overwritehost = "cloud.tantalus.lan";
        "overwrite.cli.url" = "https://cloud.tantalus.lan";
        default_phone_region = "US";
        maintenance_window_start = 1;
      };
    };

    # The nextcloud module hard-wires nginx; keep it but bind its single vhost
    # to loopback so Caddy can terminate TLS in front, like every other service.
    services.nginx.virtualHosts."cloud.tantalus.lan".listen = [
      {
        addr = "127.0.0.1";
        port = 8080;
      }
    ];

    services.caddy.virtualHosts."cloud.tantalus.lan".extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:8080
    '';
  };
}
