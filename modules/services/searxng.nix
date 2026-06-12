{
  flake.modules.nixos.searxng = {
    services.searx = {
      enable = true;
      configureUwsgi = false;
      settings = {
        server = {
          port = 11437;
          bind_address = "127.0.0.1";
          secret_key = "dcfa04c8ef5d2acb0d76c819d047428ad804a61f4452f186626895a8e4f600dd";
        };
        search = {
          safe_search = 0;
          default_lang = "en";
          formats = ["html" "json"];
        };
      };
    };

    services.caddy.virtualHosts."http://ai.tantalus.lan:11436" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8081
      '';
    };

    networking.firewall.allowedTCPPorts = [8081];
  };
}
