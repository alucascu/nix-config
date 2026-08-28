{
  flake.modules.nixos.searxng = {
    config,
    inputs,
    ...
  }: {
    imports = [inputs.self.modules.nixos.caddy];

    # Root-owned 0400 is correct here: systemd reads EnvironmentFile as root
    # before dropping privileges, so searx never needs to own the file.
    age.secrets.searx-key.file = ../../secrets/searx-key.age;

    services.searx = {
      enable = true;
      configureUwsgi = false;
      environmentFile = config.age.secrets.searx-key.path;
      settings = {
        server = {
          port = 8081;
          bind_address = "127.0.0.1";
          base_url = "http://search.tantalus.lan/";
          # Placeholder — searx-init runs envsubst over settings.yml with
          # environmentFile loaded, so the real key never enters the store.
          secret_key = "$SEARXNG_SECRET";
        };
        search = {
          safe_search = 0;
          default_lang = "en";
          formats = ["html" "json"];
        };
      };
    };

    services.caddy.virtualHosts."http://search.tantalus.lan".extraConfig = ''
      reverse_proxy 127.0.0.1:8081
    '';
  };
}
