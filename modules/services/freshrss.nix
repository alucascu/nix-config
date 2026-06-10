{
  flake.modules.nixos.freshrss = {config, ...}: {
    age.secrets.freshrss-password = {
      file = ../../secrets/freshrss-password.age;
      owner = "freshrss";
    };

    services.freshrss = {
      enable = true;
      webserver = "caddy";
      virtualHost = "rss.tantalus.lan";
      baseUrl = "https://rss.tantalus.lan";
      defaultUser = "alucascu";
      passwordFile = config.age.secrets.freshrss-password.path;
      authType = "form";
    };
  };
}
