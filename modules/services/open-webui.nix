{
  flake.modules.nixos.open-webui = {
    config,
    inputs,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [caddy searxng];

    services.open-webui = {
      enable = true;
      host = "127.0.0.1";
      port = 11435;
      environment = {
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        WEBUI_AUTH = "False";

        # Without this, everything below is seeded into
        # /var/lib/open-webui/webui.db on first boot and later edits to this
        # file are silently ignored. Nix stays the source of truth.
        ENABLE_PERSISTENT_CONFIG = "False";

        ENABLE_WEB_SEARCH = "True";
        WEB_SEARCH_ENGINE = "searxng";
        # Loopback direct — no reason to round-trip through Caddy. Port is
        # derived from searx so the two can't drift apart again.
        SEARXNG_QUERY_URL = "http://127.0.0.1:${toString config.services.searx.settings.server.port}/search?q=<query>";
        WEB_SEARCH_RESULT_COUNT = "5";
        WEB_SEARCH_CONCURRENT_REQUESTS = "10";
      };
    };

    services.caddy.virtualHosts."http://ai.tantalus.lan".extraConfig = ''
      reverse_proxy 127.0.0.1:11435
    '';
  };
}
